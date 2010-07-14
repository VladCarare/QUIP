! H0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
! H0 X
! H0 X   libAtoms+QUIP: atomistic simulation library
! H0 X
! H0 X   Portions of this code were written by
! H0 X     Albert Bartok-Partay, Silvia Cereda, Gabor Csanyi, James Kermode,
! H0 X     Ivan Solt, Wojciech Szlachta, Csilla Varnai, Steven Winfield.
! H0 X
! H0 X   Copyright 2006-2010.
! H0 X
! H0 X   These portions of the source code are released under the GNU General
! H0 X   Public License, version 2, http://www.gnu.org/copyleft/gpl.html
! H0 X
! H0 X   If you would like to license the source code under different terms,
! H0 X   please contact Gabor Csanyi, gabor@csanyi.net
! H0 X
! H0 X   Portions of this code were written by Noam Bernstein as part of
! H0 X   his employment for the U.S. Government, and are not subject
! H0 X   to copyright in the USA.
! H0 X
! H0 X
! H0 X   When using this software, please cite the following reference:
! H0 X
! H0 X   http://www.libatoms.org
! H0 X
! H0 X  Additional contributions by
! H0 X    Alessio Comisso, Chiara Gattinoni, and Gianpietro Moras
! H0 X
! H0 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

module ts_module

use libatoms_module
use QUIP_module
use MetaPotential_module
use tsParams_module

implicit none

type Images 
  type(Atoms) :: at
  logical     :: mobile
  real(dp)    :: energy
  real(dp)    :: frac 
end type Images 

type Chain_of_states 
  integer         :: N                          !% Number of images belonging to the elastic band
  type(Images), allocatable, dimension(:)    :: image   !% images 
end type Chain_of_states 

type TS
  type (Chain_of_states)     :: cos 
  logical                    :: lneb
  logical                    :: lsm
end type TS 

interface initialise 
  module procedure TS_Initialise, TS_Initialise_interp,  TS_Initialise_nointerp
end interface initialise 

interface Finalise
  module procedure TS_Finalise
end interface Finalise

interface Calc
  module procedure TS_Calc
end interface Calc

interface Print 
  module procedure TS_print_energy, TS_print, TS_print_forces
end interface Print 

interface fix 
  module procedure TS_fix
end interface fix 

contains

!--------------------------------------------------------------------------      
subroutine TS_Initialise(this,params) 
 type(TS), intent(inout) :: this
 type(tsParams)          :: params

 select case(params%simulation_method)

 case("neb")
    this%lneb = .true.
 case("sm")
    this%lsm = .true.
 case("default")
    stop "Warning:: I do not recognise the method!"   
 end select 

end subroutine TS_Initialise
!--------------------------------------------------------------------------
subroutine TS_Initialise_interp(this,at_in,at_fin,params)
  type(TS), intent(inout)               :: this 
  type(tsParams)                        :: params
  type(Atoms), intent(inout)            :: at_in 
  type(Atoms), intent(inout)            :: at_fin
  integer                               :: im
  logical, allocatable                  :: lmobile(:)

  call finalise(this) 

  call Initialise(this,params)

  allocate(this%cos%image(this%cos%N))
  this%cos%image(1:this%cos%N)%mobile = .true.

  call initialise(this%cos%image(1)%at,at_in%N,at_in%lattice)
  call initialise(this%cos%image(this%cos%N)%at,at_fin%N,at_fin%lattice)
  
  this%cos%image(1)%at          = at_in
  this%cos%image(this%cos%N)%at = at_fin
  
  do im = 2, this%cos%N-1
    call initialise(this%cos%image(im)%at,at_in%N,at_in%lattice)
    this%cos%image(im)%at = at_in
  enddo 

  if(this%cos%image(1)%at%N.ne. this%cos%image(this%cos%N)%at%N) then
    call system_abort('NEB Initialise: # of Atoms in first and last images are different')
  endif
!'

  call Interpolate_images(this)

  allocate(lmobile(this%cos%N))
  lmobile             = .true.
  lmobile(1)          = params%chain_mobile_first 
  lmobile(this%cos%N) = params%chain_mobile_last 
  call fix(this,lmobile)
  deallocate(lmobile)

  call TS_initilise_fractionate_chain(this)

end subroutine TS_Initialise_interp
!-----------------------------------------------------------------------------
subroutine TS_Initialise_nointerp(this,at_ref,conf,params)
  type(TS), intent(inout)               :: this 
  type(tsParams)                        :: params
  type(Atoms), intent(in)               :: at_ref
  real(dp), dimension(this%cos%N,3*at_ref%N) :: conf 
  integer                               :: im
  logical, allocatable                  :: lmobile(:)

  call finalise(this)

  call Initialise(this,params)

  allocate(this%cos%image(this%cos%N))
  this%cos%image(:)%mobile = .true.

  do im = 1, this%cos%N
    call initialise(this%cos%image(im)%at,at_ref%N,at_ref%lattice)
    this%cos%image(im)%at = at_ref
    this%cos%image(im)%at%pos = reshape(conf(im,:), (/3, at_ref%N/))   
    this%cos%image(im)%at%Z(:)   = at_ref%Z(:) 
    this%cos%image(im)%at%cutoff = at_ref%cutoff
    this%cos%image(im)%at%use_uniform_cutoff  = at_ref%use_uniform_cutoff
    if(associated(at_ref%move_mask)) &
            this%cos%image(im)%at%move_mask = at_ref%move_mask 
  enddo

  allocate(lmobile(this%cos%N))
  lmobile          = .true.
  lmobile(1)          = params%chain_mobile_first 
  lmobile(this%cos%N) = params%chain_mobile_last
  call fix(this,lmobile)
  deallocate(lmobile)

  call TS_initilise_fractionate_chain(this)

end subroutine TS_Initialise_nointerp
!-----------------------------------------------------------------------------
subroutine TS_initilise_fractionate_chain(this)
  type(TS), intent(inout) :: this 
  real(dp)                :: dx
 integer                  :: i

  dx = 1.d0 / dble(this%cos%N - 1._dp)
  do i = 1, this%cos%N
    this%cos%image(i)%frac = dble(i - 1._dp) * dx 
  enddo

end subroutine TS_initilise_fractionate_chain
!-----------------------------------------------------------------------------
subroutine Interpolate_images(this)
  type(TS), intent(inout)                :: this
  real(dp), allocatable, dimension(:,:)  :: increm 
  integer                 :: im,i
  real(dp), dimension(3)  :: pos_in, pos_fin
 
  if(allocated(increm)) deallocate(increm)  
  allocate(increm(3,this%cos%image(1)%at%N) )
 
  do i = 1, this%cos%image(1)%at%N
     pos_in = this%cos%image(1)%at%pos(:,i)
     pos_fin = this%cos%image(this%cos%N)%at%pos(:,i)
     increm(:,i) = diff_min_image(this%cos%image(1)%at,pos_in,pos_fin) 
  enddo
  increm = increm / real(this%cos%N-1,dp)

  do im = 2, this%cos%N -1
     this%cos%image(im)%at%pos(:,:)     = this%cos%image(1)%at%pos(:,:) + real(im-1) * increm(:,:)  
     this%cos%image(im)%at%Z(:)         = this%cos%image(1)%at%Z(:) 
     this%cos%image(im)%at%cutoff       = this%cos%image(1)%at%cutoff
     this%cos%image(im)%at%use_uniform_cutoff  = this%cos%image(1)%at%use_uniform_cutoff
     if(associated(this%cos%image(1)%at%move_mask)) &
          this%cos%image(im)%at%move_mask = this%cos%image(1)%at%move_mask 
  enddo 

end subroutine Interpolate_images
!-----------------------------------------------------------------------------
subroutine TS_Finalise(this)
 type(TS), intent(inout) :: this
 integer :: im

 if(allocated(this%cos%image)) then
    do im = 1, size(this%cos%image(:))
       call finalise(this%cos%image(im)%at)
    enddo
    deallocate(this%cos%image)  
 end if

 this%lneb = .false.
 this%lsm  = .false.
  
end subroutine TS_Finalise 

!------------------------------------------------------------------------------
subroutine TS_Calc(this,metapot,niter,params,file, mpi)
  type(TS), intent(inout)               :: this 
  type(MetaPotential), intent(inout)    :: metapot
  type(tsParams)                        :: params
  integer,   intent(inout)              :: niter 
  type(Inoutput), intent(inout)         :: file
  type(MPI_context)                     :: mpi
  real(dp), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: forces
  real(dp), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: tau 
  real(dp), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: forces_pot, forces_spring 
  real(dp), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: forces2
  real(dp), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: forces_4c
  real(dp), dimension(this%cos%N)                          :: energy, gfac, error
  real(dp)                                                 :: fnorma, gmaxstepfact, rmaxstep, energy_save
  logical                                                  :: lcheck(this%cos%N) 
  integer                                                  :: i, im, iat, is
  real(dp)                                                 :: energy_temp

  rmaxstep   = 0.1d0
  gfac       = params%minim_gfac 
  forces_pot = 0.d0
  do i = 1, this%cos%N
    call calc_connect(this%cos%image(i)%at)
    if(.not.params%simulation_hybrid) then
      call calc(metapot,this%cos%image(i)%at,e=this%cos%image(i)%energy,f=forces_pot(i,:,:),args_str=params%classical_args_str)
      call integrate_forces(this, i, forces_pot, energy_temp)
      call print('Check Integration Forces '// i // " " // this%cos%image(i)%energy // " " // energy_temp)
    else
      call calc(metapot,this%cos%image(i)%at,f=forces_pot(i,:,:))
      call integrate_forces(this, i, forces_pot, this%cos%image(i)%energy)
    endif
    energy(i) = this%cos%image(i)%energy
    call print(this,i, file, mpi)
    if(params%io_verbosity.gt.PRINT_NORMAL) call print(this,i, forces_pot(i,:,:), mpi)
  enddo

  lcheck = .false.

  steepest_loop : DO niter = 1, params%minim_max_steps 
    tau = 0._dp
    call calc_tangent(this,params%simulation_newtangent,energy,tau)

    call calc_force_perp(this, forces_pot, tau, forces)
    do im = 1, this%cos%N 
      call print('NEB: image ' // im // ' perpendicular REAL ' // (sqrt(sum(forces(im,:,:)*forces(im,:,:) )) ), PRINT_NORMAL ) 
    enddo

    if(this%lneb) then
      call calc_spring(this, tau, forces_spring, params%simulation_spring_constant) 
      if(niter.gt.params%simulation_climbing_steps.and.params%simulation_climbing) then
        is = isaddle(this) 
        do i = 1, this%cos%N
          if(i.eq.is) then
              call calc_force_4c(this,is,forces_pot,tau,forces_4c)
              forces(i,:,:) = forces_4c(i,:,:)
          else
              forces(i,:,:) = forces(i,:,:) + forces_spring(i,:,:)
          endif
        enddo
      else
        forces = forces + forces_spring
      endif

      do im=1, this%cos%N 
        call print('NEB: image ' // im // ' parallel spring ' // (sqrt(sum(forces_spring(im,:,:)*forces_spring(im,:,:) )) ), PRINT_NORMAL) 
      enddo

    endif

    forces2 = forces * forces

    do i = 1, this%cos%N

       if(.not.this%cos%image(i)%mobile) then 
         if(mod(niter,params%io_print_interval).eq.0) call print(this,i,file,mpi)
         cycle
       endif
       fnorma  = 0.0_dp
       do iat = 1, this%cos%image(i)%at%N
         fnorma = fnorma + sum(forces2(i,:,iat))
       enddo
       fnorma = dsqrt(fnorma)
       gmaxstepfact = 1.0_dp
       if (gfac(i) * fnorma > rmaxstep) then
         gmaxstepfact = 1.d0/fnorma/gfac(i) * rmaxstep
       end if
       
       energy_save = energy(i)
       if(.not.this%cos%image(i)%mobile) cycle

       do iat =  1, this%cos%image(i)%at%N
          if(associated(this%cos%image(i)%at%move_mask)) then
             if(this%cos%image(i)%at%move_mask(iat).eq.0)  cycle 
          end if
         this%cos%image(i)%at%pos(:,iat) =  this%cos%image(i)%at%pos(:,iat) + gfac(i) * forces(i,:,iat) * gmaxstepfact

       enddo 

       call calc_connect(this%cos%image(i)%at)
       
       if(.not.params%simulation_hybrid) then
          call calc(metapot,this%cos%image(i)%at,e=this%cos%image(i)%energy,f=forces_pot(i,:,:),args_str=params%classical_args_str)
       else
          call calc(metapot,this%cos%image(i)%at,f=forces_pot(i,:,:))
          call integrate_forces(this, i, forces_pot, this%cos%image(i)%energy)
       endif

       energy(i) = this%cos%image(i)%energy
       if(niter.gt.1) call check(this, energy_save, energy(i), params%minim_energy_tol, params%minim_force_tol, fnorma, error(i), lcheck(i))
    

       if(mod(niter,params%io_print_interval).eq.0) then
          call print(this,i,file,mpi)
       endif
    enddo

    if(all(lcheck(:))) then
       call print ('convergence reached at step ' // niter)
       exit
    endif

    if(this%lsm.and. mod(niter,params%simulation_freq_rep).eq.0) then
      call calc_reparameterisation(this)
    endif

    if(mod(niter,params%io_print_interval).eq.0) then
       call TS_print_xyz(this, niter, mpi)
       is = isaddle(this)
       call print("Iter " // niter // "; Saddle in = " // is )
    endif
!"
  end do steepest_loop
  niter = niter - 1 
          
end subroutine TS_Calc 
!----------------------------------------------------------------------------
subroutine calc_tangent(this,lnewtangent,energy, tau)
!----------------------------------------------------------------------------
! Tangent computed according to G. Henkelman, H Jonsson, JCP 113, 9978 (2000)
! Notice: on the first and last image tau = 0.
! It should be = tauP (tauM) but it is necessary to handle when E_0 > E_i
! and E_N > E_N-1
!----------------------------------------------------------------------------
  type(TS), intent(in)     :: this 
  logical,  intent(in)     :: lnewtangent
  real(dp), intent(inout), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: tau
  real(dp), intent(in), dimension(this%cos%N)                             :: energy
  real(dp), dimension(this%cos%N,3,this%cos%image(1)%at%N)                :: tauP, tauM
  real(dp), dimension(3)                                                  :: pos_1, pos_2
  integer                                                                :: im, iat
  real(dp)                                                               :: E1, E2, Emin, Emax
  real(dp)                                                                :: taunorm

  tau = 0._dp
  if(lnewtangent) then 
     do im = 1, this%cos%N 
       do iat = 1, this%cos%image(1)%at%N
         if(im.ne.this%cos%N) then 
           pos_1 = this%cos%image(im+1)%at%pos(:,iat)
           pos_2 = this%cos%image(im)%at%pos(:,iat)
           tauP(im,:,iat) = diff_min_image(this%cos%image(1)%at,pos_2,pos_1) 
         endif
         if(im.ne.1) then
           pos_1 = this%cos%image(im)%at%pos(:,iat)
           pos_2 = this%cos%image(im-1)%at%pos(:,iat)
           tauM(im,:,iat) = diff_min_image(this%cos%image(1)%at,pos_2,pos_1) 
         endif
        enddo
     enddo
     do im = 2, this%cos%N-1
       if(energy(im+1).gt.energy(im).and.energy(im).gt.energy(im-1)) then
          tau(im,1:3,:) = tauP(im,1:3,:)
       elseif(energy(im+1).lt.energy(im).and.energy(im).lt.energy(im-1)) then
          tau(im,1:3,:) = tauM(im,1:3,:)
       else
          E1 = abs(energy(im+1) - energy(im))
          E2 = abs(energy(im-1) - energy(im))
          if(E1.gt.E2) then
            Emax = E1
            Emin = E2
          else
            Emin = E1
            Emax = E2
          endif
          if(energy(im+1).gt.energy(im-1)) then
            tau(im,1:3,:) = tauP(im,1:3,:) * Emax + tauM(im,1:3,:) * Emin
          elseif(energy(im+1).lt.energy(im-1)) then
            tau(im,1:3,:) = tauP(im,1:3,:) * Emin + tauM(im,1:3,:) * Emax
          endif
       endif
       do iat = 1,  this%cos%image(1)%at%N
         taunorm = sqrt(sum(tau(im,:,iat) * tau(im,:,iat) ) )
         if(taunorm.gt.0.00001_dp) tau(im,:,iat) = tau(im,:,iat) / taunorm
         if(associated(this%cos%image(1)%at%move_mask)) then
            if(this%cos%image(1)%at%move_mask(iat).eq.0) tau(im,:,iat) = 0._dp
         end if
       enddo
     enddo
  else
    do im = 1, this%cos%N
       do iat = 1, this%cos%image(1)%at%N
         if(im.ne.this%cos%N) then
           pos_1 = this%cos%image(im+1)%at%pos(:,iat)
           pos_2 = this%cos%image(im)%at%pos(:,iat)
           tauP(im,:,iat) = diff_min_image(this%cos%image(1)%at,pos_2,pos_1) 
         endif
         if(im.ne.1) then
           pos_1 = this%cos%image(im)%at%pos(:,iat)
           pos_2 = this%cos%image(im-1)%at%pos(:,iat)
           tauM(im,:,iat) = diff_min_image(this%cos%image(1)%at,pos_2,pos_1) 
         endif
         tau(im,:,iat) = 0.0_dp
         if(abs(sum(tauP(im,:,iat))).gt.1.0d-10) &
                 tau(im,:,iat) = tau(im,:,iat) + tauP(im,:,iat)/sqrt(sum(tauP(im,:,iat)*tauP(im,:,iat)) ) 
            
         if(abs(sum(tauM(im,:,iat))).gt.1.0d-10) &
                 tau(im,:,iat) = tau(im,:,iat) + tauM(im,:,iat)/sqrt(sum(tauM(im,:,iat)*tauM(im,:,iat)) )
         taunorm = sqrt(sum(tau(im,:,iat) * tau(im,:,iat) ) )
         if(taunorm.gt.0.00001_dp) tau(im,:,iat) = tau(im,:,iat) / taunorm
         if(associated(this%cos%image(1)%at%move_mask)) then
            if(this%cos%image(1)%at%move_mask(iat).eq.0) tau(im,:,iat) = 0._dp
         end if
       enddo
     enddo
  endif

end subroutine calc_tangent

!--------------------------------------------------------------------
!%  Compute the force perpendicular to the path for each image
subroutine calc_force_perp(this, forces, tau, forces_perp)
  type(TS), intent(in)     :: this 
  real(dp), intent(in),    dimension(this%cos%N,3,this%cos%image(1)%at%N) :: tau
  real(dp), intent(inout), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: forces, forces_perp 
  integer   :: im, iat
  real(dp)  :: ftemp

  do im = 1, this%cos%N
   do iat = 1, this%cos%image(1)%at%N
      ftemp = sum(forces(im,:,iat) * tau(im,:,iat))
      forces_perp(im,:,iat) =  forces(im,:,iat) - ftemp * tau(im,:,iat) 
   enddo
  enddo

end  subroutine calc_force_perp
!--------------------------------------------------------------------
!%   Compute the effective force changing the sign of the parallel component 
!%   Used for the climbing image method 
subroutine calc_force_4c(this, im, forces, tau, forces_4c)
  type(TS), intent(in)     :: this
  real(dp), intent(in),    dimension(this%cos%N,3,this%cos%image(1)%at%N) :: tau
  real(dp), intent(inout), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: forces, forces_4c
  integer   :: im, iat
  real(dp)  :: ftemp

  forces_4c = 0._dp
  do iat = 1, this%cos%image(1)%at%N
      ftemp = sum(forces(im,:,iat) * tau(im,:,iat))
      forces_4c(im,:,iat) =  forces(im,:,iat) - 2._dp * ftemp * tau(im,:,iat) 
  enddo

end  subroutine calc_force_4c
!--------------------------------------------------------------------
!%  Compute the force due to the spring for each image
subroutine calc_spring(this, tau, forces, spring_constant)
  type(TS), intent(in)     :: this 
  real(dp), intent(in),    dimension(this%cos%N,3,this%cos%image(1)%at%N) :: tau
  real(dp), intent(inout), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: forces
  real(dp), dimension(3)   :: pos_im,pos_imP, pos_imM, diff_p, diff_m
  integer   :: im, iat
  real(dp)  :: ftemp, spring_constant

 forces = 0._dp
 do im = 2, this%cos%N-1 
   do iat = 1, this%cos%image(1)%at%N
     pos_imP = this%cos%image(im+1)%at%pos(:,iat)
     pos_im  = this%cos%image(im)%at%pos(:,iat)
     pos_imM = this%cos%image(im-1)%at%pos(:,iat)
     diff_p = diff_min_image(this%cos%image(1)%at,pos_im,pos_imP) 
     diff_m = diff_min_image(this%cos%image(1)%at,pos_imM,pos_im) 
     ftemp = sqrt(sum(diff_p(:)*diff_p(:))) -  sqrt(sum(diff_m(:)*diff_m(:)))
     forces(im,:,iat) = spring_constant * ftemp * tau(im,:,iat)
   enddo
 enddo

end subroutine calc_spring
!--------------------------------------------------------------------
subroutine calc_reparameterisation(this)
  type(TS), intent(inout)           :: this 
  real(dp), dimension(this%cos%N,3,this%cos%image(1)%at%N) :: dis, pos_temp_im
  real(dp), dimension(this%cos%N,this%cos%image(1)%at%N)   :: ldist
  real(dp), dimension(3)                                   :: pos_im, pos_imM
  real(dp)  :: psum
  integer   :: nim, nat, i, iat

  nim = this%cos%N 
  nat = this%cos%image(1)%at%N
  dis = 0._dp
  do i=2, nim 
   do iat = 1, nat 
!     pos_im  = realpos(this%cos%image(i)%at,iat)
!     pos_imM = realpos(this%cos%image(i-1)%at,iat)
!     dis(i,:,iat) = pos_im - pos_imM 
       
     pos_im  = this%cos%image(i)%at%pos(:,iat)
     pos_imM = this%cos%image(i-1)%at%pos(:,iat)
     dis(i,:,iat) = diff_min_image(this%cos%image(1)%at,pos_imM,pos_im) 
   enddo
  enddo

  psum =0._dp
  ldist = 0._dp
  do iat = 1, nat 
    psum = 0_dp
    do i = 1, nim
      psum = psum + sqrt(sum (dis(i,:,iat) * dis(i,:,iat) ) )
      ldist(i,iat) = psum
      pos_temp_im(i,:,iat) = realpos(this%cos%image(i)%at,iat)
    enddo
    ldist(:,iat) = ldist(:,iat)/ldist(nim,iat) 
  enddo

  do i = 1, nim
    do iat = 1, nat  
       !if(associated(this%cos%image(i)%at%move_mask)) then
       !   if(this%cos%image(i)%at%move_mask(iat).eq.0) cycle
       !end if
      pos_im(1) = interp1(nim,ldist(:,iat),pos_temp_im(:,1,iat),this%cos%image(i)%frac)
      pos_im(2) = interp1(nim,ldist(:,iat),pos_temp_im(:,2,iat),this%cos%image(i)%frac)
      pos_im(3) = interp1(nim,ldist(:,iat),pos_temp_im(:,3,iat),this%cos%image(i)%frac)
      this%cos%image(i)%at%pos(:,iat) = pos_im(:) - (this%cos%image(i)%at%lattice .mult. this%cos%image(i)%at%travel(:,iat)) 
    enddo
  enddo 

end subroutine calc_reparameterisation
!---------------------------------------------------------------------
function interp1(n,xa,ya,x)
integer  :: n
real(dp) :: xa(n), ya(n)
real(dp) :: x
real(dp) :: a, b
integer  :: k, klo, khi
real(dp) :: interp1

klo=1
khi=n
1     if (khi-klo.gt.1) then
 k=(khi+klo)/2
 if(xa(k).gt.x)then
   khi=k
 else
   klo=k
 endif
 goto 1
endif      

if(abs(xa(klo)-xa(khi)).lt.0.0000001_dp) then
 interp1 =  (ya(klo) - ya(khi))/2._dp
else
 b = (ya(klo) - ya(khi))/(xa(klo) - xa(khi))
 a = ya(klo) - b * xa(klo)
 interp1 = a + b * x
endif

return
end function interp1
!--------------------------------------------------------------------
subroutine check(this, e_old, e_new, toll, force_tol, fnorma, error, lcheck)
 type(TS) :: this
 real(dp) :: e_old, e_new
 real(dp) :: fnorma, toll
 real(dp) :: force_tol, error
 logical  :: lcheck, lcheck_ene, lcheck_force

 lcheck       = .false.
 lcheck_ene   = .false.
 lcheck_force = .false.

 if((e_old-e_new).lt.toll) then 
   lcheck_ene = .true.
   error = e_old-e_new
 else
   error = e_old-e_new
 endif
 if(fnorma/real(this%cos%image(1)%at%N,dp) .lt. force_tol) lcheck_force = .true.
 if(lcheck_ene.and.lcheck_force) lcheck = .true.

end subroutine check
!--------------------------------------------------------------------
subroutine check_forces(this, force_tol, fnorma, error, lcheck)
 type(TS) :: this
 real(dp) :: fnorma
 real(dp) :: force_tol, error
 logical  :: lcheck

 lcheck       = .false.
 if(fnorma/real(this%cos%image(1)%at%N,dp) .lt. force_tol) lcheck = .true.

end subroutine check_forces
!------------------------------------------------------------------
subroutine integrate_forces  (this, final_image, forces_pot, ene) 
  type(TS) :: this
  integer  :: final_image 
  real(dp) :: forces_pot(this%cos%N,3,this%cos%image(1)%at%N)
  real(dp) :: ene, f_dr
  real(dp), allocatable, dimension(:,:) :: dr
  integer  :: im
     

  allocate(dr(3,this%cos%image(1)%at%N))

  ene = 0.0_dp
  do im = 2, final_image 
    dr = this%cos%image(im)%at%pos - this%cos%image(im-1)%at%pos 
    f_dr = - forces_pot(im,:,:) .dot. dr

    if (im == this%cos%N) then
      ene = ene + f_dr/3.0_dp
    else if (mod(im,2) == 0) then
      ene = ene + 2.0_dp/3.0_dp*f_dr
    else
      ene = ene + 4.0_dp/3.0_dp*f_dr
    end if
  enddo
  call print ('NEB: Forces Integration ' // final_image // " " // ene)

end subroutine integrate_forces  
!------------------------------------------------------------------
subroutine TS_fix(this,lfix) 
  type(TS) :: this
  logical  :: lfix(this%cos%N)

  this%cos%image(:)%mobile = lfix(:)
   
end subroutine TS_fix
!------------------------------------------------------------------
subroutine TS_print_xyz(this, iter, mpi) 
  type(TS)          :: this
  type(MPI_context) :: mpi
  integer           :: iter
  type(CInOutput)   :: outimage
  integer           :: im

  if (.not. mpi%active .or. (mpi%active .and.mpi%my_proc == 0)) then
    do im =1, this%cos%N
      call initialise(outimage, 'neb.'//im//'.'//iter//'.xyz', action=OUTPUT)
      call write(outimage, this%cos%image(im)%at)
      call finalise(outimage)
    enddo
   end if

end subroutine TS_print_xyz
!-----------------------------------------------------------------
subroutine TS_print_energy(this, im, file, mpi) 
  type(TS)                      :: this
  type(MPI_context)             :: mpi
  type(Inoutput), intent(inout) :: file
  integer                       :: im

  if (.not. mpi%active .or. (mpi%active .and.mpi%my_proc == 0)) then
    call Print ("image= "// im // " Energy= "// this%cos%image(im)%energy, file=file)
    if(im.eq.this%cos%N) call Print ("    ", file=file)
  endif

end subroutine TS_print_energy
!-----------------------------------------------------------------
subroutine TS_print_forces(this, i, forces,mpi) 
  type(TS)            :: this
  type(InOUtput)      :: inforces
  type(MPI_context)   :: mpi
  integer, intent(in) :: i 
  real(dp), dimension(3,this%cos%image(1)%at%N) :: forces
  integer             :: ii
  character(len=20)   :: filename


  if (.not. mpi%active .or. (mpi%active .and.mpi%my_proc == 0)) then
   call print('Printing potential forces on image ' // i )
   write (filename,'(a,i0)') 'forces.',i 
   call initialise(inforces,filename, action=OUTPUT)
   do ii = 1, this%cos%image(1)%at%N
     call print(ii // " " // (forces(:,ii)), file=inforces)
   enddo
   call finalise(inforces)
  endif

end subroutine TS_print_forces
!-----------------------------------------------------------------
subroutine TS_print(this, params, mpi) 
  type(TS)          :: this
  type(tsParams)    :: params
  type(MPI_context) :: mpi
  
  if (.not. mpi%active .or. (mpi%active .and.mpi%my_proc == 0)) then
    call print( '       ')
    call Print_title('Parameters')
    call Print('Chain of state with ' // this%cos%N // ' images')
!'      
    if(this%cos%image(1)%mobile) then 
         call print ('First image: mobile')
    else
         call print ('First image: frozen')
    endif
    if(this%cos%image(this%cos%N)%mobile) then 
         call print ('Last image : mobile')
    else
         call print ('Last image : frozen')
    endif
  
   call print( '       ')
   if(this%lneb) then
       call print ('Transition state compute with NEB')
       call print ('Climbing image ' // params%simulation_climbing)
       call print ('Spring Constant ' // params%simulation_spring_constant)
       call print ('Climbing Image method ' // params%simulation_climbing)
   else
       call print ('Transition state compute with String method')
       call print ('Reparameterisation performed every ' // params%simulation_freq_rep // ' steps')
   endif 
   call print ('Tangent computed with the newtangent method ' // params%simulation_newtangent)
 endif

end subroutine TS_print
!------------------------------------------------------------------
function isaddle(this)
  type(TS) :: this
  real(dp) :: Emax
  integer  :: i
  integer  :: isaddle  

  Emax = -1.d13
  do i  = 1, this%cos%N
    if(this%cos%image(i)%energy.gt.Emax) then
       isaddle = i
       Emax = this%cos%image(i)%energy 
    endif
  enddo
  if(isaddle.gt. this%cos%N) stop 'isaddle function error'
end function

end module ts_module
