!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!X
!X     libAtoms: atomistic simulation library
!X     
!X     Copyright 2006-2007.
!X
!X     Authors: Gabor Csanyi, Steven Winfield, James Kermode
!X     Contributors: Noam Bernstein, Alessio Comisso
!X
!X     The source code is released under the GNU General Public License,
!X     version 2, http://www.gnu.org/copyleft/gpl.html
!X
!X     If you would like to license the source code under different terms,
!X     please contact Gabor Csanyi, gabor@csanyi.net
!X
!X     When using this software, please cite the following reference:
!X
!X     http://www.libatoms.org
!X
!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
!X
!X  Table module
!X  
!% A 'Table' is an extensible 2D array of integers, reals, strings and logicals.
!% The lengths of all rows are the same and the number of rows will grow and shrink 
!% as datais appended or deleted. Extra columns can also be appended, although this 
!% is envisaged to be required less often. Any of the number of integers,
!% number of reals, number of strings and number of logicals can be zero
!%
!% Integers are referenced by    'table%int'
!%
!% Reals are referenced by       'table%real'
!%
!% Strings are referenced by     'table%str'
!%
!% Logicals are referenced by    'table%logical'
!%
!% Appending to the table is through the 'append' interface.
!X
!X
!XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

! $Id: Table.f95,v 1.44 2008-07-14 10:21:42 jrk33 Exp $

! $Log: not supported by cvs2svn $
! Revision 1.43  2008/07/03 11:22:08  jrk33
! Removed some debugging code
!
! Revision 1.42  2008/07/03 11:13:37  jrk33
! Added spaces in table_print
!
! Revision 1.41  2008/06/16 13:03:09  jrk33
! Changes to allocate(): use default values if one part of table is missing, and added optional blank_rows argument. Fixed bug in append_column: new array lengths were this%N not this%max_length. Tweaked printing.
!
! Revision 1.40  2008/05/13 15:51:00  jrk33
! Added properties optional argument to table_print
!
! Revision 1.39  2008/05/13 10:51:23  jrk33
! Resolve ambigurity in append interface by adding table_append_row_or_arrays. Improved printing
!
! Revision 1.38  2008/05/10 13:41:32  saw44
! Fixed setting of logicals to 0 instead of .false.
!
! Revision 1.37  2008/05/06 18:29:20  nb326
! table_allocate error message now points out that it could be allocate or initialise
!
! Revision 1.36  2008/05/05 13:39:24  jrk33
! Major changes! Added string and logical columns. Warning: interface to table_allocate has changed, check your code
!
! Revision 1.35  2008/04/16 10:52:29  saw44
! Fixed bug in table_record_delete_multiple which did not check if the real or int parts were allocated before accessing them
!
! Revision 1.34  2008/03/03 18:16:34  jrk33
! out->file in print() interface
!
! Revision 1.33  2008/02/04 13:36:25  saw44
! Fixed binary search of zero length table
!
! Revision 1.32  2007/11/20 18:38:40  saw44
! Added search and sort interfaces. Added index returning to table_sort
!
! Revision 1.31  2007/11/17 18:10:11  saw44
! Added table_insert and sort subroutines, and search function
!
! Revision 1.30  2007/11/12 23:57:47  gc121
! added optional mask argument to find_row routine
!
! Revision 1.29  2007/10/22 16:17:10  jrk33
! ends of functions and subroutines
!
! Revision 1.28  2007/09/14 13:09:48  jrk33
! Applied checkcode, added missing names to ends of functions subroutines
!
! Revision 1.27  2007/08/14 10:44:46  nb326
! Set this%N in read_binary
!
! Revision 1.26  2007/08/10 15:33:00  jrk33
! Added routines to binary read/write 1D,2D and 3D arrays of Tables
!
! Revision 1.25  2007/08/07 11:22:11  nb326
! Faster reading/writing binary
!
! Revision 1.24  2007/07/25 08:32:45  gc121
! switched table printing to scientific format
!
! Revision 1.23  2007/07/23 15:40:18  gc121
! removed optional clause from arguments of table_append_row
!
! Revision 1.22  2007/07/23 15:19:43  gc121
! added overloads for table_append_row that take a single integer/real array
!
! Revision 1.21  2007/07/17 08:42:04  jrk33
! Changed uniq from function to subroutine
!
! Revision 1.20  2007/07/16 17:39:48  jrk33
! Fixed bug in table_record_delete_multiple which occurs if indices are repeated. Fix is to uniqify indices list after sorting
!
! Revision 1.19  2007/07/12 09:57:09  nb326
! Add remove_columns()
!
! Revision 1.18  2007/07/11 12:42:05  gc121
! added initialise interface (same as allocate)
!
! Revision 1.17  2007/07/09 16:36:05  saw44
! Fixed spurious extensions of a table if allocated length == required length in table_append_table
!
! Revision 1.16  2007/07/09 14:44:08  gc121
! made some arguments to subtable() optional, and corrected a bug in it, table_select now can take a list as well
!
! Revision 1.15  2007/06/08 10:42:42  nb326
! select_table() from a mask, uses subtable
!
! Revision 1.14  2007/04/18 01:32:21  gc121
! updated to reflect changes in printing and other naming conventions
!
! Revision 1.13  2007/04/17 09:57:19  gc121
! put copyright statement in each file
!
! Revision 1.12  2007/04/13 13:52:15  saw44
! Standardised subroutine and function references and printing argument order. Updated documentation. Removed Free interface - use finalise instead.
!
! Revision 1.11  2007/04/03 14:02:01  jrk33
! Updated doc comments
!
! Revision 1.10  2007/03/30 16:46:11  jrk33
! Modified print argument order to conform with changes to System
!
! Revision 1.9  2007/03/22 18:11:28  nb326
! Fix typo in table_extend_real_cols
!
! Revision 1.8  2007/03/22 17:27:08  nb326
! Add append_column
!
! Revision 1.7  2007/03/22 14:43:00  jrk33
! Added Delete_Multiple interface to remove multiple rows from a Table.
!
! Revision 1.6  2007/03/21 15:25:34  jrk33
! Added Zero interface to Table_Zero
!
! Revision 1.5  2007/03/12 17:02:05  jrk33
! DP to lowercase; reformatted documentation
!
! Revision 1.4  2007/03/01 13:51:46  jrk33
! Documentation comments reformatted and edited throughout. Anything starting "!(no space)%"
!  is picked up by the documentation generation script
!
! Revision 1.3  2007/02/28 15:46:47  saw44
! Allowed max_length to be zero when allocating a table. This was causing some problems when reading a Connection object in binary format where some neighbour tables has zero length
!
! Revision 1.2  2007/02/13 15:07:33  saw44
! Added Set_Increment subroutine to set the table increment length, with a check for bad values. Replaced multiple free and wipe routines with one routine each which can free/wipe up to 10 tables at a time.
!
! Revision 1.1.1.1  2006/12/04 11:11:30  gc121
! Imported sources
!
! Revision 1.49  2006/08/14 11:01:00  jrk33
! Bug fix: Allocate table in ReadB_Table even if length is zero so that Nint and Nreal are set correctly - thanks Gian
!
! Revision 1.48  2006/06/20 17:23:19  gc121
! added new copyright notice to include James, Gian, Mike and Alessandro
!
! Revision 1.47  2006/06/14 10:38:43  saw44
! Giving max_length to table_allocate now sets the increment to 1/10 of that. This should hopefully save memory. Also, I noticed that the local variable max_length is sometimes zeroed when a call to Free is made. See the commented lines in table_allocate.
!
! Revision 1.46  2006/06/07 16:25:27  jrk33
! Changed numerical constants xx.yd0 -> xx.y_dp
!
! Revision 1.45  2006/05/30 11:11:48  jrk33
! Removed declarations for unused variables
!
! Revision 1.44  2006/05/25 13:41:39  jrk33
! Removed overriden table assignment interface, causes seg faults on Tru64 unix (see STYLE.txt for full explanation)
!
! Revision 1.43  2006/04/19 15:18:54  saw44
! Changed allocate, assign and append to be consistent with extra variables in the table type and not seg fault
!
! Revision 1.42  2006/03/31 16:22:53  saw44
! Removed bug where more space was being allocated for a table before the current space was filled
!
! Revision 1.41  2006/03/03 16:27:00  gc121
! fixed log entry, accedentally committed with wrong log
!
! Revision 1.40  2006/03/03 16:16:54  gc121
! fixed bug in RMS_diff_list, now works
!
! Revision 1.39  2006/03/03 15:09:35  gc121
! added RMS_diff_list to produce the rms diff of two arrays, but only over part of the second dimension, determined by the table argument
!
! Revision 1.38  2006/02/28 15:06:31  saw44
! Expanded Wipe to take up to 4 tables at once
!
! Revision 1.37  2006/02/21 17:01:35  saw44
! Fixed bug in table_allocate. Added multiple object destructors
!
! Revision 1.36  2006/02/17 12:34:01  saw44
! Gave intents to all arguments
!
! Revision 1.35  2006/02/17 05:09:15  gc121
! put in initialisation to 0 and freeing of temporary in table_allocate
!
! Revision 1.34  2006/02/16 22:46:21  saw44
! Fixed bug where table_find_row searched in undefined portion of table
!
! Revision 1.33  2006/02/10 17:24:43  saw44
! Added allocate interface
!
! Revision 1.32  2006/02/06 16:48:22  saw44
! General Code clean-up: routine names changed to match the changes in System and linearalgebra
!
! Revision 1.31  2006/02/02 17:10:49  saw44
! Added Table_Wipe to quickly delete all data from a table, optionally zeroing it for safety
!
! Revision 1.30  2006/01/31 17:46:50  gc121
! append accepts a 1D column as well
!
! Revision 1.29  2006/01/31 17:35:11  saw44
! Added 1D append to intsize/realsize=1 tables
!
! Revision 1.28  2006/01/31 14:28:19  saw44
! Updated ReadB and WriteB argument order
!
! Revision 1.27  2006/01/31 14:00:27  gc121
! increased default length and increment to optimise
!
! Revision 1.26  2006/01/31 11:54:47  saw44
! Changed argument order in ReadB/WriteB_Table_File
!
! Revision 1.25  2006/01/30 10:41:30  gc121
! renamed table_x_part interface to x_part ; put in explicit check of >100 columns into print_table
!
! Revision 1.24  2006/01/29 17:15:58  saw44
! Added Subtable, Real_Subtable and Int_Subtable
!
! Revision 1.23  2006/01/29 16:14:01  saw44
! Added Table_Append_Arrays subroutines and improved Table_Print
!
! Revision 1.22  2006/01/29 15:02:06  gc121
! added verbosity to table_print
!
! Revision 1.21  2006/01/28 20:48:51  gc121
! fixed bug in table_allocate: it called size(intpart) or size(realpart) without checking if the optional arguments were present.
!
! Revision 1.20  2006/01/28 16:17:00  saw44
! Fixed error messages in Table_Find_Element/Row
!
! Revision 1.19  2006/01/27 19:31:30  saw44
! Fixed bug in Table_Real_Part (using intsize instead of realsize)
!
! Revision 1.18  2006/01/27 18:28:55  gc121
! changed table_find to find
!
! Revision 1.17  2006/01/26 16:29:26  saw44
! Table_Int_Part interface overloaded with functions for returning 1, some or all columns
!
! Revision 1.16  2006/01/26 16:11:46  saw44
! Added intsize and realsize variables to Table type. Added Table_Int_Part, Table_Int_Column, and same for Real
!
! Revision 1.15  2006/01/26 01:57:09  gc121
! deleted obsolete log() calls, changed printing format, renamed some routines
!
! Revision 1.14  2006/01/25 16:10:17  gc121
! uses find_in_array() to find rows in table
!
! Revision 1.13  2006/01/25 15:29:27  saw44
! Added Table_Int/Real_Column functions
!
! Revision 1.12  2006/01/24 18:24:00  gc121
! fixed typo
!
! Revision 1.11  2006/01/24 13:55:30  gc121
! added table_find routines
!
! Revision 1.10  2006/01/24 12:13:53  saw44
! Implemented the discussed changes
!
! Revision 1.9  2006/01/17 17:06:28  gc121
! General cleanup of variable names, subroutines etc.
!
! Revision 1.8  2005/12/19 17:00:38  saw44
! Added WriteB_Table and ReadB_Table
!
! Revision 1.7  2005/12/13 15:11:57  comisso
! table- table assignment fixed
!
! Revision 1.6  2005/12/02 17:07:52  comisso
!  Added assignment table=table
!
! Revision 1.5  2005/11/21 17:03:46  saw44
! Added interface for delete
!
! Revision 1.4  2005/11/17 12:00:01  comisso
! table
!
! Revision 1.2  2005/11/11 11:18:59  gc121
! forgot to comment cvs magic variables
!
! Revision 1.1.1.1  2005/11/11 10:22:24  gc121
! starting

#ifndef SIZEOF_VOID_PTR
#define SIZEOF_VOID_PTR 4
#endif

module table_module
  use system_module
  use linearalgebra_module
  use dictionary_module
  implicit none

  integer, parameter, private :: DEFAULT_TABLE_LENGTH = 100
  integer, parameter, private :: DEFAULT_TABLE_INCREMENT = 1000

  integer, parameter :: TABLE_STRING_LENGTH = 10

  type Table
     integer,allocatable, dimension(:,:)  :: int  !% (intsize,N) array of integer data
     real(dp),allocatable, dimension(:,:) :: real !% (realsize,N) array of real data
     character(TABLE_STRING_LENGTH), allocatable, dimension(:,:) ::  str !% (strsize,N) array of string data
     logical, allocatable, dimension(:,:) :: logical !% (logicalsize,N) array of logical data
     integer::increment = DEFAULT_TABLE_INCREMENT !% How many rows to grow the table by on reallocation (default 1000)
     integer::max_length = 0 !% Initial maximum length of the table before the first reallocation (default 100)
     integer::intsize = 0   !% Number of integer columns
     integer::realsize = 0  !% Number of real columns
     integer::strsize = 0   !% Number of string columns
     integer::logicalsize = 0 !% Number of logical columns
     integer::N=0 !% Number of rows
  end type Table

  !% Allocate a 'Table'. When allocating a table, you can
  !% optionally specify the number of integer and real columns and the
  !% initial amount of space to allocate ('max_length'). If a table is
  !% unallocated when append is called for the first time it will be
  !% allocated accordingly.
  interface allocate
     module procedure table_allocate
  end interface allocate

  interface initialise
     module procedure table_allocate
  end interface

  !% Finalise this table.
  interface finalise
     module procedure table_finalise
  end interface finalise

  !% Change the increment for this table.
  interface set_increment
     module procedure table_set_increment
  end interface set_increment

! This overriden interface causes seg faults on Tru64 unix, and does
! not seem to be necessary with ifort9, sun f95 or HP f95 so it's
! been removed for now.

!!$  interface assignment(=)
!!$     module procedure  table_assign_table
!!$  end interface
 
 
  !% Append rows to a table. Overloaded to be able to append single elements,
  !% arrays or other tables.
  interface append
     module procedure table_append_row_or_arrays, table_append_table
     module procedure table_append_int_element, table_append_real_element
     module procedure table_append_str_element, table_append_logical_element
     module procedure table_append_int_element_and_real_element
     module procedure table_append_int_row_real_element
     module procedure table_append_int_element_real_row
     module procedure table_append_int_array, table_append_real_array 
     module procedure table_append_str_array, table_append_logical_array
  end interface append

  !% Append 1 or more columns to a table.  Overloaded to be able to append
  !% a scalar, 1-D array (must match N rows), or other tables (must match N rows)
  interface append_column
    module procedure table_append_col_i, table_append_col_i_a
    module procedure table_append_col_r, table_append_col_r_a
    module procedure table_append_col_s, table_append_col_s_a
    module procedure table_append_col_l, table_append_col_l_a
    module procedure table_append_col_table
  end interface append_column

  !% remove a range of columns from a table's int or real parts
  interface remove_columns
    module procedure table_remove_columns
  end interface remove_columns

  !% insert a row at a given position
  interface insert
     module procedure table_insert
  end interface insert

  !% Search the integer part of a table for a given element or array.
  interface find
     module procedure table_find_element, table_find_row
  end interface find

  !% Sort a table according to its int part
  interface sort
     module procedure table_sort
  end interface sort

  !% Do a binary search (faster than find) on a pre-sorted table
  interface search
     module procedure table_search
  end interface search

  !% Print this table to the mainlog or to an inoutput object.
  interface print
     module procedure table_print, table_print_mainlog
  end interface print

  !% Utility function to return one or more columns from the integer part of a table.
  !% Since this is a function the array may be returned on the stack, so be careful
  !% when working with large tables --- the same goes for the 'real_part'
  !% interface below.
  interface int_part
     module procedure table_int_part, table_int_column, table_int_columns
  end interface int_part

  !% Utility function to return one or more columns from the real part of a table.
  interface real_part
     module procedure table_real_part, table_real_column, table_real_columns
  end interface real_part

  interface str_part
     module procedure table_str_part, table_str_column, table_str_columns
  end interface str_part

  interface logical_part
     module procedure table_logical_part, table_logical_column, table_logical_columns
  end interface logical_part

  !% Delete a row by index or by value. If by value then the match
  !% is made by the integer part of the table. The last row is copied
  !% over the row to be deleted, so the order of rows is not maintained.
  interface delete
     module procedure table_record_delete_by_index
     module procedure table_record_delete_by_value
  end interface delete

  !% Delete multiple rows from a Table. Beware, the order of rows
  !% is not maintained.
  interface delete_multiple
     module procedure table_record_delete_multiple
  end interface delete_multiple

  !% Clear this table, but keep the allocation.
  interface wipe
     module procedure table_wipe
  end interface wipe

  !% Zero all parts of this table.
  interface zero
     module procedure table_zero
  end interface zero

  !% Write a Table or array of Tables to a binary file.
  interface write_binary
     module procedure write_binary_table, write_binary_table_file
     module procedure write_binary_table_array_1d
     module procedure write_binary_table_array_2d
     module procedure write_binary_table_array_3d
  end interface write_binary

  !% Read a Table or array of Tables from a binary file.
  interface read_binary
     module procedure read_binary_table, read_binary_table_file
     module procedure read_binary_table_array_1d
     module procedure read_binary_table_array_2d
     module procedure read_binary_table_array_3d
  end interface read_binary

  private::rms_diff_list
  interface rms_diff
     module procedure rms_diff_list
  end interface

  !% Select certains rows from a table based on a mask
  private::table_select
  interface select
     module procedure table_select
  end interface select

contains

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! general functions used to allocate and deallocate tables
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


  ! Table_Allocate: Initialises a Table object ready for use.
  subroutine table_allocate(this,Nint,Nreal,Nstr,Nlogical,max_length)

    type(table),       intent(inout) :: this
    integer, optional, intent(in)    :: Nint   !% Number of integer columns
    integer, optional, intent(in)    :: Nreal !% Number of real columns
    integer, optional, intent(in)    :: Nstr !% Number of string columns
    integer, optional, intent(in)    :: Nlogical !% Number of logical columns
    integer, optional, intent(in)    :: max_length !%  Number of rows to initially allocate
    type(table)                      :: temp

    if (present(Nint) .or. present(Nreal) .or. present(Nstr) .or. present(Nlogical)) then

       ! Initialise the table to the given dimensions

       call finalise(this)
       this%max_length = DEFAULT_TABLE_LENGTH

       !If max length is present then we have info about how big the table
       !is likely to be... so set the increment accordingly
       if (present(max_length)) then
          this%max_length = max_length
          this%increment = max(1,max_length/10)
       end if

       ! Beware, interface change!
       if (.not. present(Nint) .or. .not. present(Nreal) .or. & 
            .not. present(Nstr)  .or. .not. present(Nlogical)) then
          call print('WARNING: The interface to table_allocate (allocate(table,...) and', ERROR)
	  call print('         initialise(table,...)) has changed!', ERROR)
          call print(' from call allocate(table,Nint,Nreal,length)', ERROR)
          call print(' to   call allocate(table,Nint,Nreal,Nstr,Nlogical,length)', ERROR)
          call print('Please update your code!', ERROR)
          call system_abort('table_allocate: if one of Nint, Nreal, Nstr, Nlogical is present then all must be!')
       end if

       if (present(Nint)) then
          this%intsize = max(Nint,0)
          if (this%intsize > 0) allocate(this%int(this%intsize,this%max_length))
       else
          this%intsize = 0
       end if

       if (present(Nreal)) then
          this%realsize = max(Nreal,0)
          if (this%realsize > 0) allocate(this%real(this%realsize,this%max_length))
       else
          this%realsize = 0
       end if     

       if (present(Nstr)) then
          this%strsize = max(Nstr,0)
          if (this%strsize > 0) allocate(this%str(this%strsize,this%max_length))
       else
          this%strsize = 0
       end if     

       if (present(Nlogical)) then
          this%logicalsize = max(Nlogical,0)
          if (this%logicalsize > 0) allocate(this%logical(this%logicalsize,this%max_length))
       else
          this%logicalsize = 0
       end if     
    else

       ! Change the length of the table, keeping the data
       temp = this
! DODGINESS: the value of max_length sometimes changes after the call finalise(this) line
! if (present(max_length)) write(*,*) 'max_length=',max_length
       call finalise(this)
! if (present(max_length)) write(*,*) 'max_length=',max_length
       this%max_length = temp%N
       if (present(max_length)) then
          this%max_length = max_length
          this%increment = max(1,max_length/10)
       end if
       if (temp%N > this%max_length) call system_abort('Table_Allocate: Max_Length is smaller than number of rows')

       if (temp%intsize > 0) then
          this%intsize = temp%intsize
          allocate(this%int(this%intsize,this%max_length))
          this%int(:,1:temp%N) = temp%int(:,1:temp%N)
       end if

       if (temp%realsize > 0) then
          this%realsize = temp%realsize
          allocate(this%real(this%realsize,this%max_length))
          this%real(:,1:temp%N) = temp%real(:,1:temp%N)
       end if

       if (temp%strsize > 0) then
          this%strsize = temp%strsize
          allocate(this%str(this%strsize,this%max_length))
          this%str(:,1:temp%N) = temp%str(:,1:temp%N)
       end if

       if (temp%logicalsize > 0) then
          this%logicalsize = temp%logicalsize
          allocate(this%logical(this%logicalsize,this%max_length))
          this%logical(:,1:temp%N) = temp%logical(:,1:temp%N)
       end if

       this%N = temp%N

       call finalise(temp)

    endif

  end subroutine table_allocate

  subroutine table_set_increment(this,increment)

    type(table), intent(inout) :: this
    integer,     intent(in)    :: increment

    if (increment < 1) call system_abort('Table_Set_Increment: Increment must be at least 1')

    this%increment = increment

  end subroutine table_set_increment

  !% Reduce the allocation if we can, still leaving a bit at the end, not more than 'this%increment'.
  subroutine reduce_allocation(this)
    type(table), intent(inout) :: this
    integer::nblocs

    if(this%N.gt.(this%max_length - this%increment)) return

    nblocs = this%N / this%increment + 2
    call table_allocate(this,max_length=nblocs*this%increment)
  end subroutine reduce_allocation


  ! destructor
  subroutine table_finalise(this)
    type(table), intent(inout)::this

    if(allocated(this%int)) deallocate(this%int)
    if(allocated(this%real)) deallocate(this%real)
    if(allocated(this%str)) deallocate(this%str)
    if(allocated(this%logical)) deallocate(this%logical)

    this%max_length = 0
    this%N = 0
    this%intsize = 0
    this%realsize = 0
    this%strsize = 0
    this%logicalsize = 0

  end subroutine table_finalise

  ! Zero all parts of this table.
  subroutine table_zero(this)
    type(table), intent(inout) :: this
    if(allocated(this%int)) this%int   = 0
    if(allocated(this%real)) this%real = 0.0_dp
    if(allocated(this%str)) this%str = repeat(' ',TABLE_STRING_LENGTH)
    if(allocated(this%logical)) this%logical = .false.
  end subroutine table_zero

  !% OMIT
  subroutine table_assign_table(this,other)
    type(table), intent(inout) ::this
    type(table), intent(in)    ::other
    call finalise(this)
    call table_allocate(this,other%intsize,other%realsize,&
         other%strsize,other%logicalsize,other%N) !optimised for temporary copies
    this%N=other%N
    this%increment=other%increment
    if(allocated(other%int)) this%int(:,1:this%N) = other%int(:,1:this%N)
    if(allocated(other%real)) this%real(:,1:this%N) = other%real(:,1:this%N)
    if(allocated(other%str)) this%str(:,1:this%N) = other%str(:,1:this%N)
    if(allocated(other%logical)) this%logical(:,1:this%N) = other%logical(:,1:this%N)

  end subroutine table_assign_table

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! appending to tables
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  subroutine table_append_row_or_arrays(this,intpart,realpart,strpart,logicalpart, &
       intpart_2D,realpart_2D,strpart_2D,logicalpart_2D, blank_rows)

    type(Table), intent(inout) :: this
    integer,     intent(in), optional  :: intpart(:)
    real(dp),    intent(in), optional  :: realpart(:)
    character(TABLE_STRING_LENGTH), intent(in), optional :: strpart(:)
    logical, intent(in), optional :: logicalpart(:)
    integer,  dimension(:,:), intent(in),optional    :: intpart_2D
    real(dp), dimension(:,:), intent(in),optional    :: realpart_2D
    character(TABLE_STRING_LENGTH), dimension(:,:), intent(in),optional :: strpart_2D
    logical, dimension(:,:), intent(in), optional    :: logicalpart_2D
    integer, optional, intent(in) :: blank_rows

    logical :: got1D, got2D

    got1D = present(intpart) .or. present(realpart) .or. &
         present(strpart) .or. present(logicalpart)
    got2D = present(intpart_2D) .or. present(realpart_2D) .or. &
         present(strpart_2D) .or. present(logicalpart_2D)

    if (present(blank_rows)) then
       if(allocated(this%int) .or. allocated(this%real) .or. &
            allocated(this%str) .or. allocated(this%logical)) then

          if(this%N+blank_rows > this%max_length) then ! we need more memory
             call table_allocate(this,max_length=this%N+blank_rows)
          end if
          this%N = this%N + blank_rows
          return
       else
          call system_abort('table_append_row_or_arrays: blank_rows can only be used with already allocated tables')
       end if
    else
       if (.not. got1D .and. .not. got2D) &
            call system_abort('table_append_row_or_arrays: nothing to append')

       if (got1D .and. got2D) &
            call system_abort("table_append_row_or_arrays: can't mix 1D and 2D arrays")

       if (got1D) call table_append_row(this,intpart,realpart,strpart,logicalpart)
       if (got2D) call table_append_arrays(this,intpart_2d,realpart_2d,strpart_2d,logicalpart_2d)
    end if

  end subroutine table_append_row_or_arrays

  ! append single records
  ! unless all sizes are 1 we  do multiple appends
  subroutine table_append_row(this,intpart,realpart,strpart,logicalpart)
    type(table), intent(inout) :: this
    integer,     intent(in), optional  :: intpart(:)
    real(dp),    intent(in), optional  :: realpart(:)
    character(TABLE_STRING_LENGTH), intent(in), optional :: strpart(:)
    logical, intent(in), optional :: logicalpart(:)

    integer :: intsize, realsize, strsize, logicalsize

    integer, allocatable :: use_intpart(:)
    real(dp),  allocatable  :: use_realpart(:)
    character(TABLE_STRING_LENGTH), allocatable :: use_strpart(:)
    logical, allocatable :: use_logicalpart(:)

    intsize = 0
    realsize = 0
    strsize = 0
    logicalsize = 0
    if (present(intpart)) intsize = size(intpart)
    if (present(realpart)) realsize = size(realpart)
    if (present(strpart)) strsize = size(strpart)
    if (present(logicalpart)) logicalsize = size(logicalpart)

    !Special cases: if the table has size 1
    !and the vector length is > 1 then call append_arrays
    if ((this%intsize     == 1 .and. intsize     > 1) .or. &
        (this%realsize    == 1 .and. realsize    > 1) .or. &
        (this%strsize     == 1 .and. strsize     > 1) .or. &
        (this%logicalsize == 1 .and. logicalsize > 1)) then

       ! Make local copies so we can reshape
       allocate(use_intpart(intsize))
       if (present(intpart)) use_intpart = intpart

       allocate(use_realpart(realsize))
       if (present(realpart)) use_realpart = realpart

       allocate(use_strpart(strsize))
       if (present(strpart)) use_strpart = strpart

       allocate(use_logicalpart(logicalsize))
       if (present(logicalpart)) use_logicalpart = logicalpart

       call table_append_arrays(this, reshape(use_intpart, (/1,intsize/)), &
            reshape(use_realpart, (/1,realsize/)), &
            reshape(use_strpart, (/1,strsize/)), &
            reshape(use_logicalpart, (/1,logicalsize/)))

       deallocate(use_intpart, use_realpart, use_strpart, use_logicalpart)
       
       return
    end if

    if(allocated(this%int) .or. allocated(this%real) .or. &
         allocated(this%str) .or. allocated(this%logical)) then
       if(this%N+1 > this%max_length) then ! we need more memory
          call table_allocate(this,max_length=this%N+this%increment)
       end if
    else
!       call print('allocating '//intsize//' '//realsize//' '//strsize//' '//logicalsize)
       call table_allocate(this,intsize,realsize,strsize,logicalsize)
    end if

    if (this%intsize > 0) then
       if(present(intpart)) then
          if(size(this%int,1).ne.size(intpart)) &
               call system_abort('table_append_row: appendix int part has the wrong size')
          this%int(:,this%N+1) = intpart
       else
          ! use default value of zero
          this%int(:,this%N+1) = 0 
       end if
    end if

    if (this%realsize > 0) then
       if(present(realpart)) then
          if(size(this%real,1).ne.size(realpart)) &
               call system_abort('table_append_row: appendix real part has the wrong size')
          this%real(:,this%N+1)=realpart
       else
          ! default to zero
          this%real(:,this%N+1) = 0.0_dp
       end if
    end if

    if (this%strsize > 0) then
       if(present(strpart)) then
          if(size(this%str,1).ne.size(strpart)) &
               call system_abort('table_append_row: appendix str part has the wrong size')
          this%str(:,this%N+1)=strpart
       else
          ! default to empty string
          this%str(:,this%N+1) = repeat(' ',TABLE_STRING_LENGTH)
       end if
    end if

    if (this%logicalsize > 0) then
       if(present(logicalpart)) then
          if(size(this%logical,1).ne.size(logicalpart)) &
               call system_abort('table_append_row: appendix logical part has the wrong size')
          this%logical(:,this%N+1)=logicalpart
       else
          ! default to false
          this%logical(:,this%N+1) = .false.
       end if
    end if

    ! Now increment the number of valid table rows
    this%N = this%N+1 
  end subroutine table_append_row

  
  !Appending 2D arrays to tables

  subroutine table_append_int_array(this,intpart)
    type(Table),              intent(inout) :: this
    integer,  dimension(:,:), intent(in)    :: intpart

    call table_append_arrays(this,intpart=intpart)

  end subroutine table_append_int_array

  subroutine table_append_real_array(this,realpart)
    type(Table),              intent(inout) :: this
    real(dp), dimension(:,:), intent(in)    :: realpart

    call table_append_arrays(this,realpart=realpart)

  end subroutine table_append_real_array


  subroutine table_append_str_array(this,strpart)
    type(Table),              intent(inout) :: this
    character(TABLE_STRING_LENGTH), dimension(:,:), intent(in)    :: strpart

    call table_append_arrays(this,strpart=strpart)

  end subroutine table_append_str_array


  subroutine table_append_logical_array(this,logicalpart)
    type(Table),              intent(inout) :: this
    logical, dimension(:,:), intent(in)    :: logicalpart
    call table_append_arrays(this,logicalpart=logicalpart)

  end subroutine table_append_logical_array


  subroutine table_append_arrays(this,intpart,realpart,strpart,logicalpart)
    type(Table),              intent(inout) :: this
    integer,  dimension(:,:), intent(in),optional    :: intpart
    real(dp), dimension(:,:), intent(in),optional    :: realpart
    character(TABLE_STRING_LENGTH), dimension(:,:), intent(in),optional :: strpart
    logical, dimension(:,:), intent(in), optional    :: logicalpart

    !locals
    integer :: datasize(4), datalength(4), thissize(4), length, i

    datasize(1) = 0
    datalength(1) = 0
    if (present(intpart)) then
       datasize(1) = size(intpart,1)
       datalength(1) = size(intpart,2)
    end if
    
    datasize(2) = 0
    datalength(2) = 0
    if (present(realpart)) then
       datasize(2) = size(realpart,1)
       datalength(2) = size(realpart,2)
    end if

    datasize(3) = 0
    datalength(3) = 0
    if (present(strpart)) then
       datasize(3) = size(strpart,1)
       datalength(3) = size(strpart,2)
    end if

    datasize(4) = 0
    datalength(4) = 0
    if (present(logicalpart)) then
       datasize(4) = size(logicalpart,1)
       datalength(4) = size(logicalpart,2)
    end if

    if (all(datasize == 0)) &
         call system_abort('table_append_arrays: all array widths are zero!')
    length = maxval(datalength)
    if (length == 0) &
         call system_abort('table_append_arrays: all array lengths are zero!')

    ! Check non zero lengths match
    do i=1,4
       if (datalength(i) == 0) cycle
       if (datalength(i) /= length) then
          call print(datalength)
          call system_abort('table_append_arrays: lengths mismatched between arrays')
       end if
    end do

    thissize = (/this%intsize,this%realsize,this%strsize,this%logicalsize/)
       
    !Check if the table has been allocated and allocate if not, or check for correct size
    if (all(thissize == 0)) then
       call table_allocate(this,datasize(1),datasize(2),datasize(3),datasize(4),length)
    else
       ! Check non zero length arrays are correct size
       do i=1,4
          if (datalength(i) == 0) cycle
          if (datasize(i) /= thissize(i)) &
               call system_abort('table_append_arrays: Input data sizes do not match table sizes')
       end do

       !Table already allocated. See if long enough to hold the extra data
       if (this%N+length > this%max_length) call table_allocate(this,max_length = this%N+length)
    endif

    !Actually do the append
    if (datasize(1) > 0 .and. datalength(1) > 0) this%int(:,this%N+1:this%N+length)      = intpart
    if (datasize(2) > 0 .and. datalength(2) > 0) this%real(:,this%N+1:this%N+length)     = realpart
    if (datasize(3) > 0 .and. datalength(3) > 0) this%str(:,this%N+1:this%N+length)      = strpart
    if (datasize(4) > 0 .and. datalength(4) > 0) this%logical(:,this%N+1:this%N+length)  = logicalpart

    this%N = this%N + length

  end subroutine table_append_arrays


  subroutine table_append_int_element(this,intpart)
    type(Table), intent(inout) :: this
    integer,     intent(in)    :: intpart

    call table_append_row(this,(/intpart/))

  end subroutine table_append_int_element

  subroutine table_append_real_element(this,realpart)
    type(Table), intent(inout) :: this
    real(dp),    intent(in)    :: realpart

    call table_append_row(this,realpart=(/realpart/))
  end subroutine table_append_real_element

  subroutine table_append_str_element(this,strpart)
    type(Table), intent(inout) :: this
    character(TABLE_STRING_LENGTH) :: strpart

    call table_append_row(this,strpart=(/strpart/))
  end subroutine table_append_str_element

  subroutine table_append_logical_element(this,logicalpart)
    type(Table), intent(inout) :: this
    logical, intent(in) :: logicalpart

    call table_append_row(this,logicalpart=(/logicalpart/))

  end subroutine table_append_logical_element

  subroutine table_append_int_element_and_real_element(this,intpart,realpart)
    type(Table), intent(inout) :: this
    integer,     intent(in)    :: intpart
    real(dp),    intent(in)    :: realpart

    call table_append_row(this,(/intpart/),(/realpart/))

  end subroutine table_append_int_element_and_real_element

  !overloaded append for mixed scalar and row input
  subroutine table_append_int_element_real_row(this,intpart,realpart) 
    type(table), intent(inout) :: this
    integer,     intent(in)    :: intpart
    real(dp),    intent(in)    :: realpart(:)

    call table_append_row(this,(/intpart/),realpart)

  end subroutine table_append_int_element_real_row

  !overloaded append for mixed scalar and row input 
  subroutine table_append_int_row_real_element(this,intpart,realpart) 
    type(table), intent(inout) :: this
    integer,     intent(in)    :: intpart(:)
    real(dp),    intent(in)    :: realpart

    call table_append_row(this,intpart,(/realpart/))

  end subroutine table_append_int_row_real_element

  ! append another table to this table
  subroutine table_append_table(this,other)
    type(table), intent(inout) :: this
    type(table), intent(in)    :: other

    if(allocated(this%int) .or. allocated(this%real) .or. allocated(this%str) .or. allocated(this%logical)) then
       if(this%N+other%N > this%max_length) & ! we need more memory
            call table_allocate(this,max_length=this%N+other%N)
    else ! new table
       this=other
       return
    end if

    ! we have ints
    if(allocated(this%int)) then
       if (.not.allocated(other%int))&
            call system_abort('table_append_table: appendix table has no int part!')

       if(size(this%int,1).ne.size(other%int,1))&
            call system_abort('table_append_table: appendix table has int part with wrong shape!')

       this%int(:,this%N+1:this%N+other%N) =  other%int(:,1:other%N)
    end if

    ! we have reals
    if(allocated(this%real)) then
       if (.not.allocated(other%real)) &
            call system_abort('table_append_table: appendix table has no real part!')

       if(size(this%real,1).ne.size(other%real,1))&
            call system_abort('table_append_table: appendix table has real part with wrong shape!')

       this%real(:,this%N+1:this%N+other%N) =  other%real(:,1:other%N)
    end if

    ! we have strs
    if(allocated(this%str)) then
       if (.not.allocated(other%str)) &
            call system_abort('table_append_table: appendix table has no str part!')

       if(size(this%str,1).ne.size(other%str,1))&
            call system_abort('table_append_table: appendix table has str part with wrong shape!')

       this%str(:,this%N+1:this%N+other%N) =  other%str(:,1:other%N)
    end if

    ! we have logicals
    if(allocated(this%logical)) then
       if (.not.allocated(other%logical)) &
            call system_abort('table_append_table: appendix table has no logical part!')

       if(size(this%logical,1).ne.size(other%logical,1))&
            call system_abort('table_append_table: appendix table has logical part with wrong shape!')

       this%logical(:,this%N+1:this%N+other%N) =  other%logical(:,1:other%N)
    end if


    ! update the number of rows
    this%N=this%N+other%N
  end subroutine table_append_table

  subroutine table_append_col_i(this, val, n_cols, cols)
    type(Table), intent(inout) :: this
    integer, intent(in) :: val
    integer, optional :: n_cols
    integer, intent(out), optional :: cols(2)

    integer :: use_n_cols = 1

    if (present(n_cols)) use_n_cols = n_cols

    call table_extend_int_cols(this,use_n_cols)

    this%int(this%intsize-use_n_cols+1:this%intsize,:) = val

    if (present(cols)) then
      cols(1) = this%intsize-use_n_cols+1
      cols(2) = this%intsize
    endif
  end subroutine table_append_col_i

  subroutine table_append_col_i_a(this, val_a, n_cols, cols)
    type(Table), intent(inout) :: this
    integer, intent(in) :: val_a(:)
    integer, optional :: n_cols
    integer, intent(out), optional :: cols(2)

    integer i
    integer :: use_n_cols = 1

    if (present(n_cols)) use_n_cols = n_cols
    if (size(val_a) /= this%N) call system_abort ("Called table_append_col_i_a with mismatched data size")

    call table_extend_int_cols(this,use_n_cols)
    do i=1, this%N
      this%int(this%intsize-use_n_cols+1:this%intsize,i) = val_a(i)
    end do

    if (present(cols)) then
      cols(1) = this%intsize-use_n_cols+1
      cols(2) = this%intsize
    endif
  end subroutine table_append_col_i_a

  subroutine table_append_col_r(this, val, n_cols, cols)
    type(Table), intent(inout) :: this
    real(dp), intent(in) :: val
    integer, optional :: n_cols
    integer, intent(out), optional :: cols(2)

    integer :: use_n_cols = 1

    if (present(n_cols)) use_n_cols = n_cols

    call table_extend_real_cols(this, use_n_cols)

    this%real(this%realsize-use_n_cols+1:this%realsize,:) = val

    if (present(cols)) then
      cols(1) = this%realsize-use_n_cols+1
      cols(2) = this%realsize
    endif
  end subroutine table_append_col_r

  subroutine table_append_col_r_a(this, val_a, n_cols, cols)
    type(Table), intent(inout) :: this
    real(dp), intent(in) :: val_a(:)
    integer, optional :: n_cols
    integer, intent(out), optional :: cols(2)

    integer i
    integer :: use_n_cols = 1

    if (present(n_cols)) use_n_cols = n_cols
    if (size(val_a) /= this%N) call system_abort ("Called table_append_col_r_a with mismatched data size")

    call table_extend_real_cols(this, use_n_cols)
    do i=1, this%N
      this%real(this%realsize-use_n_cols+1:this%realsize,i) = val_a(i)
    end do

    if (present(cols)) then
      cols(1) = this%realsize-use_n_cols+1
      cols(2) = this%realsize
    endif
  end subroutine table_append_col_r_a


  subroutine table_append_col_s(this, val, n_cols, cols)
    type(Table), intent(inout) :: this
    character(TABLE_STRING_LENGTH), intent(in) :: val
    integer, optional :: n_cols
    integer, intent(out), optional :: cols(2)

    integer :: use_n_cols = 1

    if (present(n_cols)) use_n_cols = n_cols

    call table_extend_str_cols(this, use_n_cols)

    this%str(this%strsize-use_n_cols+1:this%strsize,:) = val

    if (present(cols)) then
      cols(1) = this%strsize-use_n_cols+1
      cols(2) = this%strsize
    endif
  end subroutine table_append_col_s

  subroutine table_append_col_s_a(this, val_a, n_cols, cols)
    type(Table), intent(inout) :: this
    character(TABLE_STRING_LENGTH), intent(in) :: val_a(:)
    integer, optional :: n_cols
    integer, intent(out), optional :: cols(2)

    integer i
    integer :: use_n_cols = 1

    if (present(n_cols)) use_n_cols = n_cols
    if (size(val_a) /= this%N) call system_abort ("Called table_append_col_s_a with mismatched data size")

    call table_extend_str_cols(this, use_n_cols)
    do i=1, this%N
      this%str(this%strsize-use_n_cols+1:this%strsize,i) = val_a(i)
    end do

    if (present(cols)) then
      cols(1) = this%strsize-use_n_cols+1
      cols(2) = this%strsize
    endif
  end subroutine table_append_col_s_a


  subroutine table_append_col_l(this, val, n_cols, cols)
    type(Table), intent(inout) :: this
    logical, intent(in) :: val
    integer, optional :: n_cols
    integer, intent(out), optional :: cols(2)

    integer :: use_n_cols = 1

    if (present(n_cols)) use_n_cols = n_cols

    call table_extend_logical_cols(this, use_n_cols)

    this%logical(this%logicalsize-use_n_cols+1:this%logicalsize,:) = val

    if (present(cols)) then
      cols(1) = this%logicalsize-use_n_cols+1
      cols(2) = this%logicalsize
    endif
  end subroutine table_append_col_l

  subroutine table_append_col_l_a(this, val_a, n_cols, cols)
    type(Table), intent(inout) :: this
    logical, intent(in) :: val_a(:)
    integer, optional :: n_cols
    integer, intent(out), optional :: cols(2)

    integer i
    integer :: use_n_cols = 1

    if (present(n_cols)) use_n_cols = n_cols
    if (size(val_a) /= this%N) call system_abort ("Called table_append_col_l_a with mismatched data size")

    call table_extend_logical_cols(this, use_n_cols)
    do i=1, this%N
      this%logical(this%logicalsize-use_n_cols+1:this%logicalsize,i) = val_a(i)
    end do

    if (present(cols)) then
      cols(1) = this%logicalsize-use_n_cols+1
      cols(2) = this%logicalsize
    endif
  end subroutine table_append_col_l_a


  subroutine table_append_col_table(this, other)
    type(Table), intent(inout) :: this
    type(Table), intent(in) :: other

    if (this%N /= other%N) call system_abort ("Called table_append_col_table with mismatched sizes")

    if (other%intsize > 0) then
      call table_extend_int_cols(this, other%intsize)
      this%int(this%intsize-other%intsize+1:this%intsize, :) = other%int(1:other%intsize, :)
    endif
    if (other%realsize > 0) then
      call table_extend_real_cols(this, other%realsize)
      this%real(this%realsize-other%realsize+1:this%realsize, :) = other%real(1:other%realsize, :)
    endif
    if (other%strsize > 0) then
      call table_extend_str_cols(this, other%strsize)
      this%str(this%strsize-other%strsize+1:this%strsize, :) = other%str(1:other%strsize, :)
    endif
    if (other%logicalsize > 0) then
      call table_extend_logical_cols(this, other%logicalsize)
      this%logical(this%logicalsize-other%logicalsize+1:this%logicalsize, :) = other%logical(1:other%logicalsize, :)
    endif

  end subroutine table_append_col_table

  subroutine table_extend_int_cols(this, n_cols)
    type(Table), intent(inout) :: this
    integer n_cols

    integer, allocatable :: t(:,:)

    if (n_cols < 0) call system_abort ("Called table_extend_int_cols with n_cols < 0")
    if (n_cols == 0) return

    if (allocated(this%int)) then
      if (size(this%int,1) < this%intsize+n_cols) then
	allocate(t(this%intsize,this%N))
	t = this%int(1:this%intsize, 1:this%N)
	deallocate(this%int)
	allocate(this%int(this%intsize+n_cols,this%max_length))
	this%int(1:this%intsize, 1:this%N) = t(1:this%intsize, 1:this%N)
	this%int(this%intsize+1:this%intsize+n_cols,:) = 0
      endif
      this%intsize = this%intsize + n_cols
    else
      this%intsize = n_cols
      allocate(this%int(this%intsize,this%N))
      this%int = 0
    endif
  end subroutine table_extend_int_cols

  subroutine table_extend_real_cols(this, n_cols)
    type(Table), intent(inout) :: this
    integer n_cols

    real(dp), allocatable :: t(:,:)

    if (n_cols < 0) call system_abort ("Called table_extend_int_cols with n_cols < 0")
    if (n_cols == 0) return

    if (allocated(this%real)) then
      if (size(this%real,1) < this%realsize+n_cols) then
	allocate(t(this%realsize,this%N))
	t = this%real(1:this%realsize, 1:this%N)
	deallocate(this%real)
	allocate(this%real(this%realsize+n_cols,this%max_length))
	this%real(1:this%realsize, 1:this%N) = t(1:this%realsize, 1:this%N)
	this%real(this%realsize+1:this%realsize+n_cols,:) = 0
      endif
      this%realsize = this%realsize + n_cols
    else
      this%realsize = n_cols
      allocate(this%real(this%realsize,this%N))
      this%real = 0
    endif
  end subroutine table_extend_real_cols

  subroutine table_extend_str_cols(this, n_cols)
    type(Table), intent(inout) :: this
    integer n_cols

    character(TABLE_STRING_LENGTH), allocatable :: t(:,:)

    if (n_cols < 0) call system_abort ("Called table_extend_str_cols with n_cols < 0")
    if (n_cols == 0) return

    if (allocated(this%str)) then
      if (size(this%str,1) < this%strsize+n_cols) then
	allocate(t(this%strsize,this%N))
	t = this%str(1:this%strsize, 1:this%N)
	deallocate(this%str)
	allocate(this%str(this%strsize+n_cols,this%max_length))
	this%str(1:this%strsize, 1:this%N) = t(1:this%strsize, 1:this%N)
	this%str(this%strsize+1:this%strsize+n_cols,:) = repeat(' ',TABLE_STRING_LENGTH)
      endif
      this%strsize = this%strsize + n_cols
    else
      this%strsize = n_cols
      allocate(this%str(this%strsize,this%N))
      this%str = repeat(' ',TABLE_STRING_LENGTH)
    endif
  end subroutine table_extend_str_cols


  subroutine table_extend_logical_cols(this, n_cols)
    type(Table), intent(inout) :: this
    integer n_cols

    logical, allocatable :: t(:,:)

    if (n_cols < 0) call system_abort ("Called table_extend_logical_cols with n_cols < 0")
    if (n_cols == 0) return

    if (allocated(this%logical)) then
      if (size(this%logical,1) < this%logicalsize+n_cols) then
	allocate(t(this%logicalsize,this%N))
	t = this%logical(1:this%logicalsize, 1:this%N)
	deallocate(this%logical)
	allocate(this%logical(this%logicalsize+n_cols,this%max_length))
	this%logical(1:this%logicalsize, 1:this%N) = t(1:this%logicalsize, 1:this%N)
	this%logical(this%logicalsize+1:this%logicalsize+n_cols,:) = .false.
      endif
      this%logicalsize = this%logicalsize + n_cols
    else
      this%logicalsize = n_cols
      allocate(this%logical(this%logicalsize,this%N))
      this%logical = .false.
    endif
  end subroutine table_extend_logical_cols


  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! inserting a new row at a given position
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  subroutine table_insert(this,pos,intpart,realpart,strpart,logicalpart)

    type(table),                      intent(inout) :: this
    integer,                          intent(in)    :: pos
    integer,  dimension(:), optional, intent(in)    :: intpart
    real(dp), dimension(:), optional, intent(in)    :: realpart
    character(TABLE_STRING_LENGTH), dimension(:), optional, intent(in) :: strpart
    logical, dimension(:), optional, intent(in)     :: logicalpart

    !Check input arguments
    if (pos < 1 .or. pos > this%N+1) call system_abort('table_insert: cannot insert at position '//pos)

    if (present(intpart)) then
       if (this%intsize == 0) call system_abort('table insert: table does not have an int part')
       if (size(intpart) /= this%intsize) &
            call system_abort('table_insert: int size should be '//this%intsize//' and not '//size(intpart))
    end if
    if (present(realpart)) then
       if (this%realsize == 0) call system_abort('table insert: table does not have a real part')
       if (size(realpart) /= this%realsize) &
            call system_abort('table_insert: real size should be '//this%realsize//' and not '//size(realpart))
    end if
    if (present(strpart)) then
       if (this%strsize == 0) call system_abort('table insert: table does not have a str part')
       if (size(strpart) /= this%strsize) &
            call system_abort('table_insert: str size should be '//this%strsize//' and not '//size(strpart))
    end if
    if (present(logicalpart)) then
       if (this%logicalsize == 0) call system_abort('table insert: table does not have a logical part')
       if (size(logicalpart) /= this%logicalsize) &
            call system_abort('table_insert: logical size should be '//this%logicalsize//' and not '//size(logicalpart))
    end if

    if (.not.present(intpart) .and. .not.present(realpart) .and. &
         .not. present(strpart) .and. .not. present(logicalpart)) &
         call system_abort('table_insert: at least one of intpart/realpart/strpart/logicalpart must be present')

    !First check if we need to insert -- FIXME: these parameters are not optional in append()
    if (pos == this%N+1) then 
       call append(this,intpart,realpart,strpart,logicalpart)
       return
    end if

    !Make sure memory is available
    if (this%N+1 > this%max_length) call allocate(this,max_length=this%N+this%increment)
    
    !Shift everything from 'pos' to 'N' down a line and insert new data
    if (this%intsize > 0) then
       if (.not. present(intpart)) call system_abort('table_insert: missing intpart')
       this%int(:,pos+1:this%N+1) = this%int(:,pos:this%N)
       this%int(:,pos) = intpart
    end if
    if (this%realsize > 0) then
       if (.not. present(realpart)) call system_abort('table_insert: missing realpart')
       this%real(:,pos+1:this%N+1) = this%real(:,pos:this%N)
       this%real(:,pos) = realpart
    end if
    if (this%strsize > 0) then
       if (.not. present(strpart)) call system_abort('table_insert: missing strpart')
       this%str(:,pos+1:this%N+1) = this%str(:,pos:this%N)
       this%str(:,pos) = strpart
    end if
    if (this%logicalsize > 0) then
       if (.not. present(logicalpart)) call system_abort('table_insert: missing logicalpart')
       this%logical(:,pos+1:this%N+1) = this%logical(:,pos:this%N)
       this%logical(:,pos) = logicalpart
    end if

   
    !Update the row counter
    this%N = this%N + 1

  end subroutine table_insert

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! sort a table by its integer part
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  subroutine table_sort(this,idx)

    type(table),                               intent(inout) :: this
    integer, dimension(this%N),      optional, intent(out)   :: idx
    integer, dimension(this%intsize)                         :: tmp_intpart
    real(dp),dimension(this%realsize)                        :: tmp_realpart
    character(TABLE_STRING_LENGTH), dimension(this%strsize)  :: tmp_strpart
    logical, dimension(this%logicalsize)                     :: tmp_logicalpart

    integer :: i, j, vi
    logical :: have_reals, have_strs, have_logicals

    if (this%intsize == 0) return
    have_reals = (this%realsize /= 0)
    have_strs  = (this%strsize  /= 0)
    have_logicals = (this%logicalsize /= 0)

    if (present(idx)) idx = (/ (i, i=1,this%N) /)

     do i = 2, this%N

        if (int_array_ge(this%int(:,i),this%int(:,i-1))) cycle

        tmp_intpart = this%int(:,i)
        if (have_reals)    tmp_realpart    = this%real(:,i)
        if (have_strs)     tmp_strpart     = this%str(:,i)
        if (have_logicals) tmp_logicalpart = this%logical(:,i)
        if (present(idx))  vi = idx(i)

        j = i-1

        do while (j >= 1) 

           if (int_array_gt(tmp_intpart, this%int(:,j))) exit

           this%int(:,j+1) = this%int(:,j)
           if (have_reals) this%real(:,j+1) = this%real(:,j)
           if (have_strs) this%str(:,j+1) = this%str(:,j)
           if (have_logicals) this%logical(:,j+1) = this%logical(:,j)

           this%int(:,j) = tmp_intpart
           if (have_reals) this%real(:,j) = tmp_realpart
           if (have_strs) this%str(:,j) = tmp_strpart
           if (have_logicals) this%logical(:,j) = tmp_logicalpart

           if (present(idx)) then
              idx(j+1) = idx(j)
              idx(j) = vi
           end if
           j = j - 1          

        end do

     end do

  end subroutine table_sort

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! binary search a sorted table: index = 0 if not found
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  pure function table_search(this,intpart) result(index)

    type(table), intent(in)           :: this
    integer, dimension(:), intent(in) :: intpart
    integer                           :: index

    integer                           :: ilow, ihigh
    logical                           :: done

    index = 0
    if (this%N < 1) return
    ilow = 1; ihigh = this%N
    done = .false.
    
    if ( int_array_gt(this%int(:,ilow),intpart) .or. int_array_lt(this%int(:,ihigh),intpart) ) done = .true.
    if (.not.done) then
       if (all(this%int(:,ilow) == intpart)) then
          index = ilow
          done = .true.
       else if (all(this%int(:,ihigh) == intpart)) then
          index = ihigh
          done = .true.
       end if
    end if
     
    do while(.not.done)
        index = (ihigh + ilow) / 2
        if (index == ilow) then              ! value is not present. exit
           index = 0
           done = .true.
        else if (all(this%int(:,index) == intpart)) then ! value found
           done = .true.
        else if (int_array_lt(this%int(:,index),intpart)) then  ! value at this index is too low. shift lower bound
           ilow = index
        else                                 ! value at this index is too high. shift upper bound
           ihigh = index
        end if
     end do
     
   end function table_search

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! deleting rows from tables
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


  subroutine table_record_delete_by_index(this, n, keep_order)
    type(table), intent(inout) :: this
    integer,     intent(in)    :: n
    logical, intent(in), optional :: keep_order

    logical :: do_keep_order

    do_keep_order = optional_default(.true., keep_order)

    if (n > this%N .or. n < 1) then
       write(line,'(a,2(i0,a))')'table_record_delete_by_index: Tried to delete record ',n,' (N=',this%N,')'
       call system_abort(line)
    end if

    if (do_keep_order) then
      ! move all later rows back 1
      if(allocated(this%int))  this%int (:,n:this%N-1) = this%int (:,n+1:this%N)
      if(allocated(this%real)) this%real(:,n:this%N-1) = this%real(:,n+1:this%N)
      if(allocated(this%str)) this%str(:,n:this%N-1) = this%str(:,n+1:this%N)
      if(allocated(this%logical)) this%logical(:,n:this%N-1) = this%logical(:,n+1:this%N)
    else
      ! replace the row with the last row
      if(allocated(this%int))  this%int (:,n) = this%int (:,this%N)
      if(allocated(this%real)) this%real(:,n) = this%real(:,this%N)
      if(allocated(this%str)) this%str(:,n) = this%str(:,this%N)
      if(allocated(this%logical)) this%logical(:,n) = this%logical(:,this%N)
    endif

    this%N=this%N-1

    ! maybe we can reduce the memory 
    call reduce_allocation(this)

  end subroutine table_record_delete_by_index

  subroutine table_record_delete_multiple(this, indices)
    type(Table), intent(inout) :: this
    integer,     intent(in), dimension(:) :: indices

    integer :: oldN, newN, i, N, copysrc
    integer, dimension(size(indices)) :: sorted
    integer, dimension(:), allocatable :: uniqed

    !Get our own copy of the  indices so we can sort them
    sorted = indices
    call sort_array(sorted)

    !Now remove duplicates from sorted indices
    call uniq(sorted, uniqed)

    oldN = this%N
    N = size(uniqed)
    newN = oldN - N

    ! Algorithm: Find first row to be removed and last row to not be removed
    !            and swap them. Repeat until all rows to be removed are at the end.
    copysrc = oldN
    do i=1,N
       do while(is_in_array(uniqed,copysrc))
          copysrc = copysrc - 1
       end do

       if (uniqed(i) > copysrc) exit

       if (allocated(this%int))  this%int(:,uniqed(i))  = this%int(:,copysrc)
       if (allocated(this%real)) this%real(:,uniqed(i)) = this%real(:,copysrc)
       if (allocated(this%str)) this%str(:,uniqed(i)) = this%str(:,copysrc)
       if (allocated(this%logical)) this%logical(:,uniqed(i)) = this%logical(:,copysrc)

       copysrc = copysrc - 1
    end do

    this%N = newN
    call reduce_allocation(this)
    deallocate(uniqed)

  end subroutine table_record_delete_multiple


  subroutine table_record_delete_by_value(this,n, keep_order)
    type(table), intent(inout) :: this
    integer,     intent(in)    :: n(:)
    logical, intent(in), optional :: keep_order

    integer                    :: i

    if (.not.allocated(this%int)) &
         call system_abort('table_record_delete_by_value: you cannot delete by value from a table without an int part')

    if (size(n).ne.size(this%int,1)) &  
         call system_abort('table_record_delete_by_value: the row you are trying to delete has the wrong size')  

    do i=1,this%N
       if ( all(this%int(:,i) == n(:)) ) then
	call delete(this, i, keep_order)
	exit
       end if
    end do
    !maybe we can reduce the memory
    call reduce_allocation(this)
  end subroutine table_record_delete_by_value


  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! Wipe the table but keep the allocation
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  subroutine table_wipe(this,zero)
    type(Table),       intent(inout) :: this
    logical, optional, intent(in)    :: zero
    
    if (present(zero)) then
       if (zero) call table_zero(this)
    end if

    this%N = 0   

  end subroutine table_wipe

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! find a row by the integer entries (return first occurrence)
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  function table_find_element(this, n) result(i)
    type(table), intent(in):: this
    integer,     intent(in)   :: n
    integer                   :: i
    
    i = table_find_row(this, (/n/))

  end function table_find_element

  function table_find_row(this, n, mask) result(i)
    type(table),     intent(in) :: this
    integer,         intent(in) :: n(:)    ! what we are looking for
    logical,optional,intent(in) :: mask(:) ! if this exists, we only compare elements where this is true
    integer                     :: i


    if (this%intsize == 0) &
         call system_abort('Table_Find_Row: Table has no int part')

    if (size(n) /= this%intsize) &  
         call system_abort('Table_Find_Row: Row  being searched for has wrong size')  

    ! I've removed call to int_part() here as found to be bottleneck when profiling (jrk33)
    i = find_in_array(this%int(:,1:this%n), n, mask)
  end function table_find_row

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! printing 
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  subroutine table_print_mainlog(this,verbosity)
    type(table), intent(in)        :: this
    integer,     intent(in), optional :: verbosity
    call table_print(this, verbosity, mainlog)
  end subroutine table_print_mainlog
  

  subroutine table_print(this,verbosity,file,real_format,int_format,str_format,logical_format,properties,mask)
    type(table),    intent(in)        :: this
    type(inoutput), intent(inout)        :: file
    integer,        intent(in), optional :: verbosity
    character(*), optional, intent(in) :: real_format, int_format, str_format, logical_format
    type(Dictionary), intent(in), optional :: properties
    logical, optional, intent(in) :: mask(:)

    !locals
    character(10) :: my_real_format, my_int_format, my_str_format, my_logical_format
    character(100) :: fmt
    integer                              :: i, j, k, lookup(3)

    my_real_format = optional_default('f16.8',real_format)
    my_int_format  = optional_default('i8',int_format)
    my_str_format  = optional_default('a'//(TABLE_STRING_LENGTH+1),str_format)
    my_logical_format = optional_default('l3',logical_format)


    if (.not. present(properties)) then
       ! Print all columns in order, first ints then reals, strs and logicals
       do i=1,this%N
	  if (present(mask)) then
	    if (.not.mask(i)) cycle
	  endif
          line = ''
          do j=1,this%intsize
             write (fmt,'('//trim(my_int_format)//')') this%int(j,i)
             line=trim(line)//' '//trim(fmt)
          end do
          do j=1,this%realsize
             write (fmt,'('//trim(my_real_format)//')') this%real(j,i)
             line=trim(line)//' '//trim(fmt)
          end do
          do j=1,this%strsize
             write (fmt,'('//trim(my_str_format)//')') this%str(j,i)
             line=trim(line)//' '//trim(fmt)
          end do
          do j=1,this%logicalsize
             write (fmt,'('//trim(my_logical_format)//')') this%logical(j,i)
             line=trim(line)//' '//trim(fmt)
          end do
          call print(line,verbosity,file)
       end do
    else
       ! We've been given a properties dictionary telling us which columns 
       ! to print, and in what order

       do i=1,this%N
	  if (present(mask)) then
	    if (.not.mask(i)) cycle
	  endif
          line = ''
          fmt = ''
          do j=1,properties%N
             if (.not. get_value(properties,properties%keys(j),lookup)) &
                  call system_abort('table_print: error getting value of property '//trim(properties%keys(j)))
             do k=lookup(2),lookup(3)
                select case(lookup(1))
                case(PROPERTY_INT)
                   write (fmt,'('//trim(my_int_format)//')') this%int(k,i)
                   
                case(PROPERTY_REAL)
                   write (fmt,'('//trim(my_real_format)//')') this%real(k,i)
                   
                case(PROPERTY_STR)
                   write (fmt,'('//trim(my_str_format)//')') this%str(k,i)
                   
                case(PROPERTY_LOGICAL)
                   write (fmt,'('//trim(my_logical_format)//')') this%logical(k,i)
                end select
                line = trim(line)//' '//trim(fmt)
             end do
          end do
         call print(line,verbosity,file)
       end do
    end if

  end subroutine table_print

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !X
  !X  Returning parts of the table
  !X
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

  function table_int_column(this,column)
    type(Table),    intent(in)    :: this
    integer,        intent(in)    :: column
    integer, dimension(this%N)    :: table_int_column

    if (column > this%intsize) call system_abort('table_int_column: Column out of range')

    table_int_column = this%int(column,1:this%N)

  end function table_int_column

  function table_real_column(this,column)
    type(Table),    intent(in)    :: this
    integer,        intent(in)    :: column
    real(dp), dimension(this%N)   :: table_real_column

    if (column > this%realsize) call system_abort('table_real_column: Column out of range')

    table_real_column = this%real(column,1:this%N)

  end function table_real_column

  function table_str_column(this,column)
    type(Table),    intent(in)    :: this
    integer,        intent(in)    :: column
    character(TABLE_STRING_LENGTH), dimension(this%N)   :: table_str_column

    if (column > this%strsize) call system_abort('table_str_column: Column out of range')

    table_str_column = this%str(column,1:this%N)

  end function table_str_column


  function table_logical_column(this,column)
    type(Table),    intent(in)    :: this
    integer,        intent(in)    :: column
    logical, dimension(this%N)   :: table_logical_column

    if (column > this%logicalsize) call system_abort('table_logical_column: Column out of range')

    table_logical_column = this%logical(column,1:this%N)

  end function table_logical_column


  function table_int_columns(this,columns)
    type(Table),               intent(in)    :: this
    integer,                   intent(in)    :: columns(:)
    integer, dimension(size(columns),this%N) :: table_int_columns

    if (any(columns > this%intsize)) call system_abort('table_int_columns: Column out of range')

    table_int_columns = this%int(columns,1:this%N)

  end function table_int_columns

  function table_real_columns(this,columns)
    type(Table),               intent(in)     :: this
    integer,                   intent(in)     :: columns(:)
    real(dp), dimension(size(columns),this%N) :: table_real_columns

    if (any(columns > this%realsize)) call system_abort('table_real_columns: Column out of range')

    table_real_columns = this%real(columns,1:this%N)

  end function table_real_columns


  function table_str_columns(this,columns)
    type(Table),               intent(in)     :: this
    integer,                   intent(in)     :: columns(:)
    character(TABLE_STRING_LENGTH), dimension(size(columns),this%N) :: table_str_columns

    if (any(columns > this%strsize)) call system_abort('table_str_columns: Column out of range')

    table_str_columns = this%str(columns,1:this%N)

  end function table_str_columns

  function table_logical_columns(this,columns)
    type(Table),               intent(in)     :: this
    integer,                   intent(in)     :: columns(:)
    logical, dimension(size(columns),this%N)  :: table_logical_columns

    if (any(columns > this%logicalsize)) call system_abort('table_logical_columns: Column out of range')

    table_logical_columns = this%logical(columns,1:this%N)

  end function table_logical_columns


  function table_int_part(this)
    type(Table), intent(in)                     :: this
    integer,     dimension(this%intsize,this%N) :: table_int_part

    if (this%intsize == 0) call system_abort('table_int_part: Table has no integer part')
    
    table_int_part = this%int(:,1:this%N)

  end function table_int_part

  function table_real_part(this)
    type(Table), intent(in)                       :: this
    real(dp),    dimension(this%realsize,this%N ) :: table_real_part

    if (this%realsize == 0) call system_abort('table_real_part: Table has no real part')
    
    table_real_part = this%real(:,1:this%N)

  end function table_real_part

  function table_str_part(this)
    type(Table), intent(in)                       :: this
    character(TABLE_STRING_LENGTH), dimension(this%strsize,this%N ) :: table_str_part

    if (this%strsize == 0) call system_abort('table_str_part: Table has no str part')
    
    table_str_part = this%str(:,1:this%N)

  end function table_str_part

  function table_logical_part(this)
    type(Table), intent(in)                       :: this
    logical, dimension(this%logicalsize,this%N )  :: table_logical_part

    if (this%logicalsize == 0) call system_abort('table_logical_part: Table has no logical part')
    
    table_logical_part = this%logical(:,1:this%N)

  end function table_logical_part



  !Create a table from selected elements of another table

  function subtable(this,rows,intcols,realcols,strcols,logicalcols)
    type(Table),           intent(in) :: this
    integer, dimension(:), intent(in) :: rows
    integer, dimension(:), intent(in),optional :: intcols
    integer, dimension(:), intent(in),optional :: realcols
    integer, dimension(:), intent(in),optional :: strcols
    integer, dimension(:), intent(in),optional :: logicalcols
    type(Table)                       :: subtable

    integer, dimension(:), allocatable :: use_intcols, use_realcols, use_strcols, use_logicalcols
    integer :: i

    !First check none of the requested rows/columns are out of bounds

    if (any(rows > this%N)) call system_abort('subtable: Row out of range')
    
    if(present(intcols)) then
       if(any(intcols > this%intsize)) call system_abort('subtable: Integer column out of range')
       allocate(use_intcols(size(intcols)))
       use_intcols = intcols
    else
       allocate(use_intcols(this%intsize))
       use_intcols = (/ (i, i=1,this%intsize ) /)
    end if
    
    if(present(realcols)) then
       if(any(realcols > this%realsize)) call system_abort('subtable: Real column out of range')
       allocate(use_realcols(size(realcols)))
       use_realcols = realcols
    else
       allocate(use_realcols(this%realsize))
       use_realcols = (/ (i, i=1,this%realsize )/)
    end if
    
    if(present(strcols)) then
       if(any(strcols > this%strsize)) call system_abort('subtable: Str column out of range')
       allocate(use_strcols(size(strcols)))
       use_strcols = strcols
    else
       allocate(use_strcols(this%strsize))
       use_strcols = (/ (i, i=1,this%strsize ) /)
    end if
    
    if(present(logicalcols)) then
       if(any(logicalcols > this%logicalsize)) call system_abort('subtable: Logical column out of range')
       allocate(use_logicalcols(size(logicalcols)))
       use_logicalcols = logicalcols
    else
       allocate(use_logicalcols(this%logicalsize))
       use_logicalcols = (/ (i, i=1,this%logicalsize ) /)
    end if

!    call allocate(subtable, size(use_intcols),size(use_realcols),size(use_strcols),size(use_logicalcols))

    ! gfortran is fussier than ifort about passing empty arrays, so we have to do this ugly switch over all
    ! permuations of null and non-null columns

    if (this%intsize /= 0 .and. this%realsize /= 0 .and. this%strsize /= 0 .and. this%logicalsize /= 0) then
       ! case 0
       
       call append(subtable,intpart_2d=this%int(use_intcols,rows),&
            realpart_2d=this%real(use_realcols,rows), &
            strpart_2d=this%str(use_strcols,rows), &
            logicalpart_2d=this%logical(use_logicalcols,rows))

    else if (this%intsize /= 0 .and. this%realsize /= 0 .and. this%strsize /= 0 .and. this%logicalsize == 0) then
       ! case 1

       call append(subtable,intpart_2d=this%int(use_intcols,rows),&
            realpart_2d=this%real(use_realcols,rows), &
            strpart_2d=this%str(use_strcols,rows))

    else if (this%intsize /= 0 .and. this%realsize /= 0 .and. this%strsize == 0 .and. this%logicalsize /= 0) then
       ! case 2
       
       call append(subtable,intpart_2d=this%int(use_intcols,rows),&
            realpart_2d=this%real(use_realcols,rows), &
            logicalpart_2d=this%logical(use_logicalcols,rows))

    else if (this%intsize /= 0 .and. this%realsize /= 0 .and. this%strsize == 0 .and. this%logicalsize == 0) then
       ! case 3
       
       call append(subtable,intpart_2d=this%int(use_intcols,rows),&
            realpart_2d=this%real(use_realcols,rows))

    else if (this%intsize /= 0 .and. this%realsize == 0 .and. this%strsize /= 0 .and. this%logicalsize /= 0) then
       ! case 4
       
       call append(subtable,intpart_2d=this%int(use_intcols,rows),&
            strpart_2d=this%str(use_strcols,rows), &
            logicalpart_2d=this%logical(use_logicalcols,rows))

    else if (this%intsize /= 0 .and. this%realsize == 0 .and. this%strsize /= 0 .and. this%logicalsize == 0) then
       ! case 5
       
       call append(subtable,intpart_2d=this%int(use_intcols,rows),&
            strpart_2d=this%str(use_strcols,rows))

    else if (this%intsize /= 0 .and. this%realsize == 0 .and. this%strsize == 0 .and. this%logicalsize /= 0) then
       ! case 6
       
       call append(subtable,intpart_2d=this%int(use_intcols,rows),&
            logicalpart_2d=this%logical(use_logicalcols,rows))

    else if (this%intsize /= 0 .and. this%realsize == 0 .and. this%strsize == 0 .and. this%logicalsize == 0) then
       ! case 7
       
       call append(subtable,intpart_2d=this%int(use_intcols,rows))

    else if (this%intsize == 0 .and. this%realsize /= 0 .and. this%strsize /= 0 .and. this%logicalsize /= 0) then
       ! case 8
       
       call append(subtable, &
            realpart_2d=this%real(use_realcols,rows), &
            strpart_2d=this%str(use_strcols,rows), &
            logicalpart_2d=this%logical(use_logicalcols,rows))

    else if (this%intsize == 0 .and. this%realsize /= 0 .and. this%strsize /= 0 .and. this%logicalsize == 0) then
       ! case 9

       call append(subtable, &
            realpart_2d=this%real(use_realcols,rows), &
            strpart_2d=this%str(use_strcols,rows))

    else if (this%intsize == 0 .and. this%realsize /= 0 .and. this%strsize == 0 .and. this%logicalsize /= 0) then
       ! case 10
       
       call append(subtable, &
            realpart_2d=this%real(use_realcols,rows), &
            logicalpart_2d=this%logical(use_logicalcols,rows))

    else if (this%intsize == 0 .and. this%realsize /= 0 .and. this%strsize == 0 .and. this%logicalsize == 0) then
       ! case 11
       
       call append(subtable, &
            realpart_2d=this%real(use_realcols,rows))

    else if (this%intsize == 0 .and. this%realsize == 0 .and. this%strsize /= 0 .and. this%logicalsize /= 0) then
       ! case 12
       
       call append(subtable, &
            strpart_2d=this%str(use_strcols,rows), &
            logicalpart_2d=this%logical(use_logicalcols,rows))

    else if (this%intsize == 0 .and. this%realsize == 0 .and. this%strsize /= 0 .and. this%logicalsize == 0) then
       ! case 13
       
       call append(subtable, &
            strpart_2d=this%str(use_strcols,rows))

    else if (this%intsize == 0 .and. this%realsize == 0 .and. this%strsize == 0 .and. this%logicalsize /= 0) then
       ! case 14
       
       call append(subtable, &
            logicalpart_2d=this%logical(use_logicalcols,rows))

    else if (this%intsize == 0 .and. this%realsize == 0 .and. this%strsize == 0 .and. this%logicalsize == 0) then
       ! case 15
       
       call system_abort('subtable: source table is empty')

    end if

    deallocate(use_intcols, use_realcols, use_strcols, use_logicalcols)

  end function subtable

  function real_subtable(this,rows,cols)
    type(Table),           intent(in) :: this
    integer, dimension(:), intent(in) :: rows
    integer, dimension(:), intent(in) :: cols
    type(Table)                       :: Real_Subtable
    integer, dimension(0)             :: intcols

    real_subtable = subtable(this,rows,intcols,cols)

  end function real_subtable

  function int_subtable(this,rows,cols)
    type(Table),           intent(in) :: this
    integer, dimension(:), intent(in) :: rows
    integer, dimension(:), intent(in) :: cols
    type(Table)                       :: int_subtable
    integer, dimension(0)             :: realcols
    
    int_subtable = subtable(this,rows,cols,realcols)

  end function int_subtable

  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  !
  !
  ! File read/write
  !
  !
  !XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

   subroutine write_binary_table(this,file)
      type(Table),     intent(in) :: this
      type(Inoutput),  intent(inout) :: file
      call write_binary('Table',file)
      call write_binary(this%intsize,file)
      call write_binary(this%realsize,file)
      call write_binary(this%strsize,file)
      call write_binary(this%logicalsize,file)
      call write_binary(this%N,file)
      if (this%intsize > 0 .and. this%N > 0) call write_binary(this%int(:,1:this%N),file)
      if (this%realsize > 0 .and. this%N > 0) call write_binary(this%real(:,1:this%N),file)
      if (this%strsize > 0 .and. this%N > 0) call write_binary(this%str(:,1:this%N),file)
      if (this%logicalsize > 0 .and. this%N > 0) call write_binary(this%logical(:,1:this%N),file)

   end subroutine write_binary_table

   subroutine read_binary_table(this,file)
      type(Table),     intent(inout)      :: this
      type(Inoutput),  intent(inout)      :: file
      integer                             :: Nint,Nreal,Nstr,Nlogical,length
      character(5)                        :: id
      call finalise(this) 
      call read_binary(id,file)
      if (id /= 'Table') then
         write(line,'(a,a)')'read_binary_table: Bad Table structure in file ',file%filename
         call system_abort(line)
      end if
      call read_binary(Nint,file)
      call read_binary(Nreal,file)
      call read_binary(Nstr, file)
      call read_binary(Nlogical, file)
      call read_binary(length,file)
      call table_allocate(this,Nint,Nreal,Nstr,Nlogical,length)
      this%N = length
      if (Nint > 0 .and. length > 0) call read_binary(this%int(:,1:length), file)
      if (Nreal > 0 .and. length > 0) call read_binary(this%real(:,1:length), file)
      if (Nstr > 0 .and. length > 0) call read_binary(this%str(:,1:length), file)
      if (Nlogical > 0 .and. length > 0) call read_binary(this%logical(:,1:length), file)

   end subroutine read_binary_table


  subroutine write_binary_table_file(this,filename)
    type(table), intent(in) :: this
    character(TABLE_STRING_LENGTH),intent(in)    :: filename
    type(inoutput)             :: file
    call initialise(file,filename=filename,isformatted=.false.)
    call write_binary(this,file)
    call finalise(file)
  end subroutine write_binary_table_file
  
  subroutine read_binary_table_file(this,filename)
    type(table),  intent(inout) :: this
    character(TABLE_STRING_LENGTH), intent(in)    :: filename
    type(inoutput)              :: file
    call finalise(this)
    call initialise(file,filename=filename,isformatted=.false.)
    call read_binary(this,file)
    call finalise(file)
  end subroutine read_binary_table_file


  ! Write a 1D array of Table objects. All elements must have the same intsize,
  ! realsize, strsize and logicalsize, but don't have to be the same length.
  subroutine write_binary_table_array_1d(array, file)
    type(Table), dimension(:), intent(in) :: array
    type(Inoutput), intent(inout) :: file

    integer :: intsize, realsize, strsize, logicalsize, i, pos
    integer, dimension(:,:), allocatable :: intdata
    real(dp), dimension(:,:), allocatable :: realdata
    character(TABLE_STRING_LENGTH), dimension(:,:), allocatable :: strdata
    logical, dimension(:,:), allocatable :: logicaldata

    if (size(array) < 1) &
         call system_abort('write_binary_table_array_1d: array of Tables is of zero length')

    intsize = array(1)%intsize
    realsize = array(1)%realsize
    strsize = array(1)%strsize
    logicalsize = array(1)%logicalsize

    if (.not. (all(array%intsize == intsize) .and. all(array%realsize == realsize) .and. &
               all(array%strsize == strsize) .and. all(array%logicalsize == logicalsize))) &
         call system_abort('write_binary_table_array_1d: all Tables must have same intsize/realsize/strsize/logicalsize')

    if (intsize == 0 .and. realsize == 0 .and. strsize == 0 .and. logicalsize == 0) &
         call system_abort('write_binary_table_array_1d: all sizes are zero')
    
    call write_binary('TableArray1D',file)

    call write_binary(size(array), file)
    call write_binary(intsize, file)
    call write_binary(realsize, file)
    call write_binary(strsize, file)
    call write_binary(logicalsize, file)

    ! Write lengths of each table
    call write_binary(array%N, file)

    if (intsize /= 0)  allocate(intdata(intsize,sum(array%N)))
    if (realsize /= 0) allocate(realdata(realsize,sum(array%N)))
    if (strsize /= 0) allocate(strdata(strsize,sum(array%N)))
    if (logicalsize /= 0) allocate(logicaldata(logicalsize,sum(array%N)))


    ! Copy data into temp arrays
    pos=1
    do i=1,size(array)
       if (intsize /= 0) &
            intdata(:,pos:pos+array(i)%N-1)  = array(i)%int(:, 1:array(i)%N)
       if (realsize /= 0) &
            realdata(:,pos:pos+array(i)%N-1) = array(i)%real(:,1:array(i)%N)
       if (strsize /= 0) &
            strdata(:,pos:pos+array(i)%N-1) = array(i)%str(:,1:array(i)%N)
       if (logicalsize /= 0) &
            logicaldata(:,pos:pos+array(i)%N-1) = array(i)%logical(:,1:array(i)%N)
       pos = pos + array(i)%N
    end do

    if (intsize /= 0)  then
       call write_binary(intdata, file)
       deallocate(intdata)
    end if

    if (realsize /= 0) then
       call write_binary(realdata, file)
       deallocate(realdata)
    end if

    if (strsize /= 0) then
       call write_binary(strdata, file)
       deallocate(strdata)
    end if

    if (logicalsize /= 0) then
       call write_binary(logicaldata, file)
       deallocate(logicaldata)
    end if
    
  end subroutine write_binary_table_array_1d

  ! Read a 1D array of Table objects of the same intsize,realsize, strsize
  ! and logicalsize but different lengths
  subroutine read_binary_table_array_1d(array, file)
    type(Table), dimension(:), intent(inout), allocatable :: array
    type(Inoutput), intent(inout) :: file

    character(12) :: id
    integer :: i, pos, size_array, intsize, realsize, strsize, logicalsize
    integer, dimension(:), allocatable :: lengths
    integer, dimension(:,:), allocatable :: intdata
    real(dp), dimension(:,:), allocatable :: realdata
    character(TABLE_STRING_LENGTH), dimension(:,:), allocatable :: strdata
    logical, dimension(:,:), allocatable :: logicaldata


    call read_binary(id,file)
    if (id /= 'TableArray1D') then
       write(line,'(a,a)')'read_binary_table_array_1d: Bad Table array structure in file ',file%filename
       call system_abort(line)
    end if

    call read_binary(size_array, file)

    if (allocated(array)) deallocate(array)
    allocate(array(size_array))

    call read_binary(intsize, file)
    call read_binary(realsize, file)
    call read_binary(strsize, file)
    call read_binary(logicalsize, file)

    allocate(lengths(size_array))
    call read_binary(lengths, file)

    if (intsize /= 0)  then
       allocate(intdata(intsize, sum(lengths)))
       call read_binary(intdata, file)
    end if

    if (realsize /= 0) then
       allocate(realdata(realsize, sum(lengths)))
       call read_binary(realdata, file)
    end if

    if (strsize /= 0) then
       allocate(strdata(strsize, sum(lengths)))
       call read_binary(strdata, file)
    end if

    if (logicalsize /= 0) then
       allocate(logicaldata(logicalsize, sum(lengths)))
       call read_binary(logicaldata, file)
    end if

    pos=1
    do i=1,size_array
       call table_allocate(array(i), intsize, realsize, strsize, logicalsize, lengths(i))
       
       if (intsize /= 0) &
            array(i)%int(:,1:lengths(i)) = intdata(:,pos:pos+lengths(i)-1) 

       if (realsize /= 0) &
            array(i)%real(:,1:lengths(i)) = realdata(:,pos:pos+lengths(i)-1)

       if (strsize /= 0) &
            array(i)%str(:,1:lengths(i)) = strdata(:,pos:pos+lengths(i)-1)

       if (logicalsize /= 0) &
            array(i)%logical(:,1:lengths(i)) = logicaldata(:,pos:pos+lengths(i)-1)
       
       array(i)%N = lengths(i)

       pos = pos + lengths(i)
    end do

    deallocate(lengths)
    if (intsize /= 0)     deallocate(intdata)
    if (realsize /= 0)    deallocate(realdata)
    if (strsize /= 0)     deallocate(strdata)
    if (logicalsize /= 0) deallocate(logicaldata)

  end subroutine read_binary_table_array_1d


  ! Write a 2D array of Table objects. All elements must have the same intsize,
  ! realsize, strsize and logicalsize but don't have to be the same length.
  subroutine write_binary_table_array_2d(array, file)
    type(Table), dimension(:,:), intent(in) :: array
    type(Inoutput), intent(inout) :: file

    integer :: intsize, realsize, strsize, logicalsize, i, j, pos, na, nb
    integer, dimension(:,:), allocatable :: intdata
    real(dp), dimension(:,:), allocatable :: realdata
    character(TABLE_STRING_LENGTH), dimension(:,:), allocatable :: strdata
    logical, dimension(:,:), allocatable :: logicaldata


    if (size(array) < 1) &
         call system_abort('write_binary_table_array_2d: array of Tables is of zero length')

    intsize     = array(1,1)%intsize
    realsize    = array(1,1)%realsize
    strsize     = array(1,1)%strsize
    logicalsize = array(1,1)%logicalsize

    if (.not. (all(array%intsize == intsize) .and. all(array%realsize == realsize) &
         .and. all(array%strsize == strsize) .and. all(array%logicalsize == logicalsize))) &
         call system_abort('write_binary_table_array_2d: all Tables must have same intsize and realsize')

    if (intsize == 0 .and. realsize == 0 .and. strsize == 0 .and. logicalsize == 0) &
         call system_abort('write_binary_table_array_2d: all sizes are zero')
    
    call write_binary('TableArray2D',file)

    na = size(array,1)
    nb = size(array,2)
    call write_binary(shape(array), file)
    call write_binary(intsize, file)
    call write_binary(realsize, file)
    call write_binary(strsize, file)
    call write_binary(logicalsize, file)


    ! Write lengths of each table
    call write_binary(array%N, file)

    if (intsize /= 0)  allocate(intdata(intsize,sum(array%N)))
    if (realsize /= 0) allocate(realdata(realsize,sum(array%N)))
    if (strsize /= 0) allocate(strdata(strsize,sum(array%N)))
    if (logicalsize /= 0) allocate(logicaldata(logicalsize,sum(array%N)))

    ! Copy data into temp arrays
    pos=1
    do j=1,nb
       do i=1,na
          if (intsize /= 0) &
               intdata(:,pos:pos+array(i,j)%N-1)  = array(i,j)%int(:, 1:array(i,j)%N)
          if (realsize /= 0) &
               realdata(:,pos:pos+array(i,j)%N-1) = array(i,j)%real(:,1:array(i,j)%N)
          if (strsize /= 0) &
               strdata(:,pos:pos+array(i,j)%N-1) = array(i,j)%str(:,1:array(i,j)%N)
          if (logicalsize /= 0) &
               logicaldata(:,pos:pos+array(i,j)%N-1) = array(i,j)%logical(:,1:array(i,j)%N)

          pos = pos + array(i,j)%N
       end do
    end do

    if (intsize /= 0)  then
       call write_binary(intdata, file)
       deallocate(intdata)
    end if

    if (realsize /= 0) then
       call write_binary(realdata, file)
       deallocate(realdata)
    end if

    if (strsize /= 0) then
       call write_binary(strdata, file)
       deallocate(strdata)
    end if

    if (logicalsize /= 0) then
       call write_binary(logicaldata, file)
       deallocate(logicaldata)
    end if
    
  end subroutine write_binary_table_array_2d

  ! Read a 2D array of Table objects of the same intsize, realsize, strsize and 
  ! logicalsize but can be different lengths
  subroutine read_binary_table_array_2d(array, file)
    type(Table), dimension(:,:), intent(inout), allocatable :: array
    type(Inoutput), intent(inout) :: file

    character(12) :: id
    integer :: i, j, pos, shape_array(2), intsize, realsize, strsize, logicalsize, na, nb
    integer, dimension(:,:), allocatable :: lengths
    integer, dimension(:,:), allocatable :: intdata
    real(dp), dimension(:,:), allocatable :: realdata
    character(TABLE_STRING_LENGTH), dimension(:,:), allocatable :: strdata
    logical, dimension(:,:), allocatable :: logicaldata


    call read_binary(id,file)
    if (id /= 'TableArray2D') then
       write(line,'(a,a)')'read_binary_table_array_2d: Bad Table array structure in file ',file%filename
       call system_abort(line)
    end if

    call read_binary(shape_array, file)
    na = shape_array(1)
    nb = shape_array(2)

    if (allocated(array)) deallocate(array)
    allocate(array(na,nb))

    call read_binary(intsize, file)
    call read_binary(realsize, file)
    call read_binary(strsize, file)
    call read_binary(logicalsize, file)

    allocate(lengths(na,nb))
    call read_binary(lengths, file)

    if (intsize /= 0)  then
       allocate(intdata(intsize, sum(lengths)))
       call read_binary(intdata, file)
    end if

    if (realsize /= 0) then
       allocate(realdata(realsize, sum(lengths)))
       call read_binary(realdata, file)
    end if

    if (strsize /= 0) then
       allocate(strdata(strsize, sum(lengths)))
       call read_binary(strdata, file)
    end if

    if (logicalsize /= 0) then
       allocate(logicaldata(logicalsize, sum(lengths)))
       call read_binary(logicaldata, file)
    end if

    pos=1
    do i=1,na
       do j=1,nb
          call table_allocate(array(i,j), intsize, realsize, strsize, logicalsize, lengths(i,j))
          
          if (intsize /= 0) &
               array(i,j)%int(:,1:lengths(i,j)) = intdata(:,pos:pos+lengths(i,j)-1) 

          if (realsize /= 0) &
               array(i,j)%real(:,1:lengths(i,j)) = realdata(:,pos:pos+lengths(i,j)-1)

          if (strsize /= 0) &
               array(i,j)%str(:,1:lengths(i,j)) = strdata(:,pos:pos+lengths(i,j)-1)

          if (logicalsize /= 0) &
               array(i,j)%logical(:,1:lengths(i,j)) = logicaldata(:,pos:pos+lengths(i,j)-1)
       
          array(i,j)%N = lengths(i,j)
          
          pos = pos + lengths(i,j)
       end do
    end do

    deallocate(lengths)
    if (allocated(intdata))  deallocate(intdata)
    if (allocated(realdata)) deallocate(realdata)
    if (allocated(strdata))  deallocate(strdata)
    if (allocated(logicaldata)) deallocate(logicaldata)

  end subroutine read_binary_table_array_2d



  ! Write a 3D array of Table objects. All elements must have the same intsize,
  ! realsize, strsize and logicalsize but don't have to be the same length.
  subroutine write_binary_table_array_3d(array, file)
    type(Table), dimension(:,:,:), intent(in) :: array
    type(Inoutput), intent(inout) :: file

    integer :: intsize, realsize, strsize, logicalsize, i, j, k, pos, na, nb, nc
    integer, dimension(:,:), allocatable :: intdata
    real(dp), dimension(:,:), allocatable :: realdata
    character(TABLE_STRING_LENGTH), dimension(:,:), allocatable :: strdata
    logical, dimension(:,:), allocatable :: logicaldata


    if (size(array) < 1) &
         call system_abort('write_binary_table_array_3d: array of Tables is of zero length')

    intsize = array(1,1,1)%intsize
    realsize = array(1,1,1)%realsize
    strsize = array(1,1,1)%strsize
    logicalsize = array(1,1,1)%logicalsize

    if (.not. (all(array%intsize == intsize) .and. all(array%realsize == realsize) &
         .and. all(array%strsize == strsize) .and. all(array%logicalsize == logicalsize))) &
         call system_abort('write_binary_table_array_2d: all Tables must have same intsize and realsize')

    if (intsize == 0 .and. realsize == 0 .and. strsize == 0 .and. logicalsize == 0) &
         call system_abort('write_binary_table_array_2d: all sizes are zero')
    
    call write_binary('TableArray3D',file)

    na = size(array,1)
    nb = size(array,2)
    nc = size(array,3)
    call write_binary(shape(array), file)
    call write_binary(intsize, file)
    call write_binary(realsize, file)
    call write_binary(strsize, file)
    call write_binary(logicalsize, file)

    ! Write lengths of each table
    call write_binary(reshape(array%N,(/na*nb*nc/)), file)

    if (intsize /= 0)  allocate(intdata(intsize,sum(array%N)))
    if (realsize /= 0) allocate(realdata(realsize,sum(array%N)))
    if (strsize /= 0) allocate(strdata(strsize,sum(array%N)))
    if (logicalsize /= 0) allocate(logicaldata(logicalsize,sum(array%N)))

    ! Copy data into temp arrays
    pos=1
    do k=1,nc
       do j=1,nb
          do i=1,na
             if (intsize /= 0) &
                  intdata(:,pos:pos+array(i,j,k)%N-1)  = array(i,j,k)%int(:, 1:array(i,j,k)%N)
             if (realsize /= 0) &
                  realdata(:,pos:pos+array(i,j,k)%N-1) = array(i,j,k)%real(:,1:array(i,j,k)%N)
             if (strsize /= 0) &
                  strdata(:,pos:pos+array(i,j,k)%N-1) = array(i,j,k)%str(:,1:array(i,j,k)%N)
             if (logicalsize /= 0) &
                  logicaldata(:,pos:pos+array(i,j,k)%N-1) = array(i,j,k)%logical(:,1:array(i,j,k)%N)
             pos = pos + array(i,j,k)%N
          end do
       end do
    end do

    if (intsize /= 0)  then
       call write_binary(intdata, file)
       deallocate(intdata)
    end if

    if (realsize /= 0) then
       call write_binary(realdata, file)
       deallocate(realdata)
    end if

    if (strsize /= 0) then
       call write_binary(strdata, file)
       deallocate(strdata)
    end if

    if (logicalsize /= 0) then
       call write_binary(logicaldata, file)
       deallocate(logicaldata)
    end if
    
  end subroutine write_binary_table_array_3d

  ! Read a 3D array of Table objects of the same intsize and realsize but
  ! different lengths
  subroutine read_binary_table_array_3d(array, file)
    type(Table), dimension(:,:,:), intent(inout), allocatable :: array
    type(Inoutput), intent(inout) :: file

    character(12) :: id
    integer :: i, j, k, pos, shape_array(3), intsize, realsize, strsize, logicalsize, na, nb, nc
    integer, dimension(:), allocatable :: tmp
    integer, dimension(:,:,:), allocatable :: lengths
    integer, dimension(:,:), allocatable :: intdata
    real(dp), dimension(:,:), allocatable :: realdata
    character(TABLE_STRING_LENGTH), dimension(:,:), allocatable :: strdata
    logical, dimension(:,:), allocatable :: logicaldata


    call read_binary(id,file)
    if (id /= 'TableArray3D') then
       write(line,'(a,a)')'read_binary_table_array_3d: Bad Table array structure in file ',file%filename
       call system_abort(line)
    end if

    call read_binary(shape_array, file)
    na = shape_array(1)
    nb = shape_array(2)
    nc = shape_array(3)

    if (allocated(array)) deallocate(array)
    allocate(array(na,nb,nc))

    call read_binary(intsize, file)
    call read_binary(realsize, file)
    call read_binary(strsize, file)
    call read_binary(logicalsize, file)

    allocate(lengths(na,nb,nc))
    allocate(tmp(na*nb*nc))
    call read_binary(tmp, file)
    lengths = reshape(tmp, (/na,nb,nc/))
    deallocate(tmp)

    if (intsize /= 0)  then
       allocate(intdata(intsize, sum(lengths)))
       call read_binary(intdata, file)
    end if

    if (realsize /= 0) then
       allocate(realdata(realsize, sum(lengths)))
       call read_binary(realdata, file)
    end if

    if (strsize /= 0) then
       allocate(strdata(strsize, sum(lengths)))
       call read_binary(strdata, file)
    end if

    if (logicalsize /= 0) then
       allocate(logicaldata(logicalsize, sum(lengths)))
       call read_binary(logicaldata, file)
    end if

    pos=1
    do k=1,nc
       do j=1,nb
          do i=1,na
             call table_allocate(array(i,j,k), intsize, realsize, strsize, logicalsize, lengths(i,j,k))
      
             if (intsize /= 0) &
                  array(i,j,k)%int(:,1:lengths(i,j,k)) = intdata(:,pos:pos+lengths(i,j,k)-1) 

             if (realsize /= 0) &
                  array(i,j,k)%real(:,1:lengths(i,j,k)) = realdata(:,pos:pos+lengths(i,j,k)-1)

             if (strsize /= 0) &
                  array(i,j,k)%str(:,1:lengths(i,j,k)) = strdata(:,pos:pos+lengths(i,j,k)-1)

             if (logicalsize /= 0) &
                  array(i,j,k)%logical(:,1:lengths(i,j,k)) = logicaldata(:,pos:pos+lengths(i,j,k)-1)
       
             array(i,j,k)%N = lengths(i,j,k)

             pos = pos + lengths(i,j,k)

          end do
       end do
    end do

    deallocate(lengths)
    if (intsize /= 0)  deallocate(intdata)
    if (realsize /= 0) deallocate(realdata)
    if (strsize /= 0) deallocate(strdata)
    if (logicalsize /= 0) deallocate(logicaldata)

  end subroutine read_binary_table_array_3d


  function rms_diff_list(array1, array2, list)
    real(dp), dimension(:,:), intent(in) :: array1, array2
    type(table)                          :: list
    real(dp)                             :: rms_diff_list, d
    integer                              :: i,j, n
    call check_size('Array 2',array2,shape(array1),'rms_diff')

    rms_diff_list = 0.0_dp
    do n = 1,list%N
       j = list%int(1,n)
       do i = 1, size(array1,1)
          d = array1(i,j) - array2(i,j)
          rms_diff_list = rms_diff_list + d * d
       end do
    end do
    rms_diff_list = rms_diff_list / real(list%N*size(array1,1),dp)
    rms_diff_list = sqrt(rms_diff_list)
  end function rms_diff_list   

  subroutine table_select(to, from, row_mask, row_list)
    type(table), intent(inout) :: to
    type(table), intent(in) :: from
    integer, intent(in), optional :: row_list(:)
    logical, intent(in), optional :: row_mask(:)

    integer, allocatable :: rows(:)
    integer i, N_rows

    if ((.not. present(row_list) .and. .not. present(row_mask)) .or. (present(row_list) .and. present(row_mask))) &
         call system_abort('table_select: either list or mask must be present (but not both)')

    call finalise(to)

    if(present(row_list)) then ! we have a row_list
       to = subtable(from, row_list)
    else ! we have a row_mask
       if (from%N /= size(row_mask)) &
            call system_abort("table_select mismatched sizes from " // from%N // " mask " // size(row_mask))

       N_rows = count(row_mask)
       allocate(rows(N_rows))
       ! build up a row list
       N_rows = 1
       do i=1, from%N
          if (row_mask(i)) then
             rows(N_rows) = i
             N_rows = N_rows + 1
          endif
       end do

       to = subtable(from, rows)

       deallocate(rows)
    end if

  end subroutine table_select

subroutine table_remove_columns(this, int_col_min, int_col_max, real_col_min, real_col_max, &
     str_col_min, str_col_max, logical_col_min, logical_col_max)
  type(Table), intent(inout) :: this
  integer, intent(in), optional :: int_col_min, int_col_max
  integer, intent(in), optional :: real_col_min, real_col_max
  integer, intent(in), optional :: str_col_min, str_col_max
  integer, intent(in), optional :: logical_col_min, logical_col_max

  integer my_int_col_min, my_int_col_max, my_real_col_min, my_real_col_max
  integer my_str_col_min, my_str_col_max, my_logical_col_min, my_logical_col_max
  integer i
  type(Table) subtab

  if (present(int_col_min)) then
    my_int_col_min = int_col_min
    my_int_col_max = my_int_col_min
    if (present(int_col_max)) my_int_col_max = int_col_max
  else
    if (present(int_col_max)) call system_abort("table_remove_columns has int_col_max but no int_col_min")
    my_int_col_min = 1
    my_int_col_max = 0
  endif

  if (present(real_col_min)) then
    my_real_col_min = real_col_min
    my_real_col_max = my_real_col_min
    if (present(real_col_max)) my_real_col_max = real_col_max
  else
    if (present(real_col_max)) call system_abort("table_remove_columns has real_col_max but no real_col_min")
    my_real_col_min = 1
    my_real_col_max = 0
  endif

  if (present(str_col_min)) then
    my_str_col_min = str_col_min
    my_str_col_max = my_str_col_min
    if (present(str_col_max)) my_str_col_max = str_col_max
  else
    if (present(str_col_max)) call system_abort("table_remove_columns has str_col_max but no str_col_min")
    my_str_col_min = 1
    my_str_col_max = 0
  endif

  if (present(logical_col_min)) then
    my_logical_col_min = logical_col_min
    my_logical_col_max = my_logical_col_min
    if (present(logical_col_max)) my_logical_col_max = logical_col_max
  else
    if (present(logical_col_max)) call system_abort("table_remove_columns has logical_col_max but no logical_col_min")
    my_logical_col_min = 1
    my_logical_col_max = 0
  endif

  subtab = subtable(this, (/ (i,i=1,this%N) /), &
       intcols = (/ (i,i=1,my_int_col_min-1),(i,i=my_int_col_max+1,this%intsize) /), &
       realcols = (/ (i,i=1,my_real_col_min-1),(i,i=my_real_col_max+1,this%realsize) /), &
       strcols = (/ (i,i=1,my_str_col_min-1),(i,i=my_str_col_max+1,this%strsize) /), &
       logicalcols = (/ (i,i=1,my_logical_col_min-1),(i,i=my_logical_col_max+1,this%logicalsize) /))
  this = subtab

end subroutine table_remove_columns

subroutine table_address(this, int_loc, real_loc, str_loc, logical_loc)
  type(Table), intent(in) :: this
  integer(SIZEOF_VOID_PTR), intent(out) :: int_loc, real_loc, str_loc, logical_loc

  int_loc = 0
  real_loc = 0
  str_loc = 0
  logical_loc = 0

  if (this%intsize /= 0)    int_loc     = loc(this%int)
  if (this%realsize /= 0)   real_loc    = loc(this%real)
  if (this%strsize /= 0)    str_loc     = loc(this%str)
  if (this%logicalsize /=0) logical_loc = loc(this%logical)

end subroutine table_address

end module table_module
