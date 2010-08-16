# HQ XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# HQ X
# HQ X   quippy: Python interface to QUIP atomistic simulation library
# HQ X
# HQ X   Copyright James Kermode 2010
# HQ X
# HQ X   These portions of the source code are released under the GNU General
# HQ X   Public License, version 2, http://www.gnu.org/copyleft/gpl.html
# HQ X
# HQ X   If you would like to license the source code under different terms,
# HQ X   please contact James Kermode, james.kermode@gmail.com
# HQ X
# HQ X   When using this software, please cite the following reference:
# HQ X
# HQ X   http://www.jrkermode.co.uk/quippy
# HQ X
# HQ XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

from quippy import *
from quippy.xyz import *
from quippy.netcdf import *
import unittest, itertools, sys, quippy
from quippytest import *


class TestCInOutput(QuippyTestCase):

   def setUp(self):
      self.at = supercell(diamond(5.44,14), 2,2,2)
      self.at.add_property('log', False)
      self.at.params['dummy_real'] = 1.0
      self.at.params['dummy_int'] = 2
      self.at.params['dummy_int_a'] = [1,2,3]
      self.at.params['dummy_real_a'] = [1.0,2.0,3.0]
      self.at.params['dummy_int_a2'] = farray([1,2,3,4,5,6,7,8,9]).reshape(3,3)
      self.at.params['dummy_real_a2'] = farray([1.0,2,3,4,5,6,7,8,9]).reshape(3,3)
      self.at.params['dummy_log'] = True
      self.at.params['dummy_log_a'] = [True, True, False]
      self.al = AtomsList([ supercell(diamond(5.44+0.01*x,14),2,2,2) for x in range(5) ])
      for at in self.al:
         at.params.update(self.at.params)

      self.xyz_ref =  ['64\n', 'dummy_real=1.00000000 dummy_int=2 dummy_int_a="1       2       3" dummy_real_a="1.00000000      2.00000000      3.00000000" dummy_int_a2="1        4        7        2        5        8        3        6        9" dummy_real_a2="1.00000000       4.00000000       7.00000000       2.00000000       5.00000000       8.00000000       3.00000000       6.00000000       9.00000000" dummy_log=T dummy_log_a="T T F" Lattice="10.88000000       0.00000000       0.00000000       0.00000000      10.88000000       0.00000000       0.00000000       0.00000000      10.88000000" Properties=species:S:1:pos:R:3:Z:I:1:log:L:1\n',
                       'Si              0.00000000      0.00000000      0.00000000      14    F\n',
                       'Si              1.36000000      1.36000000      1.36000000      14    F\n',
                       'Si              2.72000000      2.72000000      0.00000000      14    F\n',
                       'Si              4.08000000      4.08000000      1.36000000      14    F\n',
                       'Si              2.72000000      0.00000000      2.72000000      14    F\n',
                       'Si              4.08000000      1.36000000      4.08000000      14    F\n',
                       'Si              0.00000000      2.72000000      2.72000000      14    F\n',
                       'Si              1.36000000      4.08000000      4.08000000      14    F\n',
                       'Si              0.00000000      0.00000000      5.44000000      14    F\n',
                       'Si              1.36000000      1.36000000      6.80000000      14    F\n',
                       'Si              2.72000000      2.72000000      5.44000000      14    F\n',
                       'Si              4.08000000      4.08000000      6.80000000      14    F\n',
                       'Si              2.72000000      0.00000000      8.16000000      14    F\n',
                       'Si              4.08000000      1.36000000      9.52000000      14    F\n',
                       'Si              0.00000000      2.72000000      8.16000000      14    F\n',
                       'Si              1.36000000      4.08000000      9.52000000      14    F\n',
                       'Si              0.00000000      5.44000000      0.00000000      14    F\n',
                       'Si              1.36000000      6.80000000      1.36000000      14    F\n',
                       'Si              2.72000000      8.16000000      0.00000000      14    F\n',
                       'Si              4.08000000      9.52000000      1.36000000      14    F\n',
                       'Si              2.72000000      5.44000000      2.72000000      14    F\n',
                       'Si              4.08000000      6.80000000      4.08000000      14    F\n',
                       'Si              0.00000000      8.16000000      2.72000000      14    F\n',
                       'Si              1.36000000      9.52000000      4.08000000      14    F\n',
                       'Si              0.00000000      5.44000000      5.44000000      14    F\n',
                       'Si              1.36000000      6.80000000      6.80000000      14    F\n',
                       'Si              2.72000000      8.16000000      5.44000000      14    F\n',
                       'Si              4.08000000      9.52000000      6.80000000      14    F\n',
                       'Si              2.72000000      5.44000000      8.16000000      14    F\n',
                       'Si              4.08000000      6.80000000      9.52000000      14    F\n',
                       'Si              0.00000000      8.16000000      8.16000000      14    F\n',
                       'Si              1.36000000      9.52000000      9.52000000      14    F\n',
                       'Si              5.44000000      0.00000000      0.00000000      14    F\n',
                       'Si              6.80000000      1.36000000      1.36000000      14    F\n',
                       'Si              8.16000000      2.72000000      0.00000000      14    F\n',
                       'Si              9.52000000      4.08000000      1.36000000      14    F\n',
                       'Si              8.16000000      0.00000000      2.72000000      14    F\n',
                       'Si              9.52000000      1.36000000      4.08000000      14    F\n',
                       'Si              5.44000000      2.72000000      2.72000000      14    F\n',
                       'Si              6.80000000      4.08000000      4.08000000      14    F\n',
                       'Si              5.44000000      0.00000000      5.44000000      14    F\n',
                       'Si              6.80000000      1.36000000      6.80000000      14    F\n',
                       'Si              8.16000000      2.72000000      5.44000000      14    F\n',
                       'Si              9.52000000      4.08000000      6.80000000      14    F\n',
                       'Si              8.16000000      0.00000000      8.16000000      14    F\n',
                       'Si              9.52000000      1.36000000      9.52000000      14    F\n',
                       'Si              5.44000000      2.72000000      8.16000000      14    F\n',
                       'Si              6.80000000      4.08000000      9.52000000      14    F\n',
                       'Si              5.44000000      5.44000000      0.00000000      14    F\n',
                       'Si              6.80000000      6.80000000      1.36000000      14    F\n',
                       'Si              8.16000000      8.16000000      0.00000000      14    F\n',
                       'Si              9.52000000      9.52000000      1.36000000      14    F\n',
                       'Si              8.16000000      5.44000000      2.72000000      14    F\n',
                       'Si              9.52000000      6.80000000      4.08000000      14    F\n',
                       'Si              5.44000000      8.16000000      2.72000000      14    F\n',
                       'Si              6.80000000      9.52000000      4.08000000      14    F\n',
                       'Si              5.44000000      5.44000000      5.44000000      14    F\n',
                       'Si              6.80000000      6.80000000      6.80000000      14    F\n',
                       'Si              8.16000000      8.16000000      5.44000000      14    F\n',
                       'Si              9.52000000      9.52000000      6.80000000      14    F\n',
                       'Si              8.16000000      5.44000000      8.16000000      14    F\n',
                       'Si              9.52000000      6.80000000      9.52000000      14    F\n',
                       'Si              5.44000000      8.16000000      8.16000000      14    F\n',
                       'Si              6.80000000      9.52000000      9.52000000      14    F\n']

   def tearDown(self):
      if os.path.exists('test.xyz'): os.remove('test.xyz')
      if os.path.exists('test.nc'): os.remove('test.nc')
      if os.path.exists('test.xyz.idx'): os.remove('test.xyz.idx')
      if os.path.exists('test2.xyz'): os.remove('test2.xyz')
      if os.path.exists('test2.xyz.idx'): os.remove('test2.xyz.idx')
      if os.path.exists('quartz.xyz'): os.remove('quartz.xyz')
      if os.path.exists('quartz.xyz.idx'): os.remove('quartz.xyz.idx')
      if os.path.exists('quartz.nc'): os.remove('quartz.nc')

   def testsinglexyz(self):
      self.at.write('test.xyz')
      at = Atoms('test.xyz')
      self.assertAtomsEqual(self.at, at)
      self.assertEqual(self.xyz_ref, open('test.xyz', 'r').readlines())

   def testsinglexyzprefix(self):
      self.at.write('test.xyz', prefix='PREFIX')
      lines = open('test.xyz').readlines()
      self.assert_(all([line[:len('PREFIX')] == 'PREFIX' for line in lines]))
      lines_without_prefix = [line[len('PREFIX '):] for line in lines]
      at = Atoms(''.join(lines_without_prefix), format='string')
      self.assertAtomsEqual(self.at, at)

   def testsinglenc(self):
      self.at.write('test.nc')
      at = Atoms('test.nc')
      self.assertEqual(self.at, at)

   def testmultixyz(self):
      self.al.write('test.xyz')
      al = AtomsList('test.xyz')
      self.assertEqual(len(al), 5)
      self.assertEqual(len(self.al), len(al))
      self.assertEqual(list(self.al), list(al))

   def testmultixyzprefix(self):
      self.al.write('test.xyz', prefix='PREFIX')
      lines = open('test.xyz').readlines()
      self.assert_(all([line[:len('PREFIX')] == 'PREFIX' for line in lines]))

   def testmultinc(self):
      self.al.write('test.nc')
      al = AtomsList('test.nc')
      self.assertEqual(list(self.al), list(al))      

   def testxyzlowlevel(self):
      cio = CInOutput("test.xyz", OUTPUT, append=False)
      for a in self.al:
         cio.write(a)
      cio.close()

      cio = CInOutput("test.xyz")
      a = []
      for i in range(5):
         a.append(cio.read())
      self.assertEqual(a, list(self.al))      

   def testxyzlowlevel2(self):
      cio = CInOutput("test.xyz", OUTPUT, append=False)
      for a in self.al:
         a.write(cio)
      cio.close()

      cio = CInOutput("test.xyz")
      a = []
      for i in range(5):
         a.append(cio.read())
      self.assertEqual(a, list(self.al))      

   def testnclowlevel(self):
      cio = CInOutput("test.nc", OUTPUT)
      for a in self.al:
         cio.write(a)
      cio.close()

      cio = CInOutput("test.nc")
      a = []
      for i in range(5):
         a.append(cio.read())
      self.assertEqual(a, list(self.al))      

   def testwritecio(self):
      cio = CInOutput("test2.xyz", OUTPUT)
      self.al.write(cio)
      cio.close()
      al = AtomsList("test2.xyz")
      self.assertEqual(list(al), list(self.al))

   def testreadcio(self):
      self.al.write("test.xyz")
      cio = CInOutput("test.xyz", INPUT)
      al = AtomsList(cio)
      self.assertEqual(list(al), list(self.al))
      cio.close()

   def testframe_random_access(self):
      self.al.write("test.xyz")
      cio = CInOutput("test.xyz", INPUT)
      error = farray(0)
      at = cio.read(frame=4)
      self.assertArrayAlmostEqual(at.lattice, 2*(5.44+0.01*4)*fidentity(3))
      cio.close()

   def testframe_out_of_range(self):
      self.al.write("test.xyz")
      cio = CInOutput("test.xyz", INPUT)
      self.assertRaises(RuntimeError, cio.read, frame=5)
      cio.close()

   def testwrite_single_xyz_properties(self):
      self.at.write('test.xyz', properties=['species','pos'])
      at = Atoms('test.xyz')
      self.assertEqual(sorted(at.properties.keys()), sorted(['species', 'pos', 'Z']))
      self.assertArrayAlmostEqual(self.at.pos, at.pos)
      self.assertEqual(list(self.at.z), list(at.z))

   def testwrite_multi_xyz_properties(self):
      self.al.write('test.xyz', properties=['species','pos'])
      al = AtomsList('test.xyz')
      for at,at_ref in zip(al, self.al):
         self.assertEqual(sorted(at.properties.keys()), sorted(['species', 'pos', 'Z']))
         self.assertArrayAlmostEqual(at.pos, at_ref.pos)
         self.assertEqual(list(at.z), list(at_ref.z))

   def test_non_orthorhombic_xyz(self):
      from quippy.sio2 import quartz_params
      aq1 = alpha_quartz(**quartz_params['ASAP_JRK'])
      aq1.write('quartz.xyz')
      aq2 = Atoms('quartz.xyz')
      orig_params = get_lattice_params(aq1.lattice)
      xyz_params  = get_lattice_params(aq2.lattice)
      self.assertArrayAlmostEqual(orig_params, xyz_params)

   def test_non_orthorhombic_nc(self):
      from quippy.sio2 import quartz_params
      aq1 = alpha_quartz(**quartz_params['ASAP_JRK'])
      aq1.map_into_cell()
      aq1.write('quartz.nc', netcdf4=False)
      aq2 = Atoms('quartz.nc')
      orig_params = get_lattice_params(aq1.lattice)
      nc_params   = get_lattice_params(aq2.lattice)
      self.assertArrayAlmostEqual(orig_params, nc_params)

   def test_read_string(self):
      s = ''.join(self.xyz_ref)
      cio = CInOutput()
      at = cio.read(str=s)
      self.assertAtomsEqual(at, self.at)

   def test_read_ext_string(self):
      es = Extendable_str()
      es.concat(''.join(self.xyz_ref))
      cio = CInOutput()
      at = cio.read(estr=es)
      self.assertAtomsEqual(at, self.at)

   def test_read_loop(self):
      import resource
      max_open_files_soft, max_open_files_hard = resource.getrlimit(resource.RLIMIT_NOFILE)
      self.at.write('test.xyz')
      for i in range(2*max_open_files_soft):
         a = Atoms('test.xyz', frame=0)

   def test_write_loop(self):
      import resource
      max_open_files_soft, max_open_files_hard = resource.getrlimit(resource.RLIMIT_NOFILE)
      for i in range(2*max_open_files_soft):
         self.at.write('test.xyz')

   def test_read_bad_range_1(self):
      self.at.write('test.xyz')
      self.assertRaises(RuntimeError, Atoms, 'test.xyz', range=[1,self.at.n+1])

   def test_read_bad_range_2(self):
      self.at.write('test.xyz')
      self.assertRaises(RuntimeError, Atoms, 'test.xyz', range=[12, 10])

   def test_read_xyz_range_all(self):
      self.at.write('test.xyz')
      at = Atoms('test.xyz', range=[1,64])
      self.assertAtomsEqual(at, self.at)

   def test_read_xyz_range_subset(self):
      self.at.write('test.xyz')
      at = Atoms('test.xyz', range=[1,32])
      sub = self.at.select(list=frange(1,32), orig_index=False)
      self.assertAtomsEqual(at, sub)

   def test_read_nc_range_all(self):
      self.at.write('test.nc')
      at = Atoms('test.nc', range=[1,64])
      self.assertAtomsEqual(at, self.at)

   def test_read_nc_range_subset(self):
      self.at.write('test.nc')
      at = Atoms('test.nc', range=[1,32])
      sub = self.at.select(list=frange(1,32), orig_index=False)
      self.assertAtomsEqual(at, sub)

            

try:
   import netCDF4
   got_netcdf4 = True
except ImportError:
   got_netcdf4 = False

class TestPythonNetCDF(QuippyTestCase):
   def setUp(self):
      self.at = supercell(diamond(5.44,14), 2,2,2)
      self.al = AtomsList([ supercell(diamond(5.44+0.01*x,14),2,2,2) for x in range(5) ])
      self.al.write('test3.nc', netcdf4=False)

   def tearDown(self):
      if os.path.exists('test3.nc'): os.remove('test3.nc')
      if os.path.exists('dataset.nc'): os.remove('dataset.nc')

   def testpupynere_read(self):
      from quippy.pupynere import netcdf_file
      nc = netcdf_file('test3.nc', 'r')
      al = AtomsList(nc, format=quippy.netcdf.netcdf_file)
      self.assertEqual(list(self.al), list(al))
      nc.close()

   if got_netcdf4:
      
      def testnetcdf4_read(self):
         from netCDF4 import Dataset
         nc = Dataset('test3.nc','r')
         al = AtomsList(nc)
         for a, b in zip(self.al, al):
            self.assertAtomsEqual(a, b)
         nc.close()

      def testnetcdf4_write(self):
         from netCDF4 import Dataset
         nc = Dataset('dataset.nc','w')
         al2 = AtomsList(self.al)
         al2.write(nc)
         nc.close()
         al = AtomsList('dataset.nc')
         self.assertEqual(list(self.al), list(al))

class TestPuPyXYZ(QuippyTestCase):

   def setUp(self):
      self.at = supercell(diamond(5.44, 14), 2, 2, 2)
      self.at.add_property('log', False)
      self.at.params['dummy_real'] = 1.0
      self.at.params['dummy_int'] = 2
      self.at.params['dummy_int_a'] = [1,2,3]
      self.at.params['dummy_real_a'] = [1.0,2.0,3.0]
      self.at.params['dummy_int_a2'] = farray([1,2,3,4,5,6,7,8,9]).reshape(3,3)
      self.at.params['dummy_real_a2'] = farray([1.0,2,3,4,5,6,7,8,9]).reshape(3,3)
      self.at.params['dummy_log'] = True
      self.at.params['dummy_log_a'] = [True, True, False]
      self.al = AtomsList(self.at for x in range(5))
      self.al = AtomsList([ supercell(diamond(5.44+0.01*x,14),2,2,2) for x in range(5) ])
      for a in self.al:
         a.params.update(self.at.params)
         a.add_property('log', False)


   def tearDown(self):
      if os.path.exists('test.xyz'): os.remove('test.xyz')

   def testsinglexyz(self):
      self.at.write(PuPyXYZWriter('test.xyz'))
      at = Atoms(PuPyXYZReader('test.xyz'))
      self.assertAtomsEqual(at, self.at)

   def testmultixyz(self):
      self.al.write(PuPyXYZWriter('test.xyz'))
      al = AtomsList(PuPyXYZReader('test.xyz'), lazy=False)
      self.assertEqual(len(al), 5)
      self.assertEqual(len(self.al), len(al))
      self.assertEqual(list(self.al), list(al))

   def teststring(self):
      s = self.at.write('string')
      a = Atoms(s, format='string')
      self.assertEqual(a, self.at)

   def testmultistring(self):
      s = self.al.write('string')
      al = AtomsList(s, format='string')
      self.assertEqual(list(al), list(self.al))

   def testwrite_single_xyz_properties(self):
      self.at.write('test.xyz', properties=['species','pos'], format='pupyxyz')
      at = Atoms('test.xyz', format='pupyxyz')
      self.assertEqual(sorted(at.properties.keys()), sorted(['species', 'pos', 'Z']))
      self.assertArrayAlmostEqual(self.at.pos, at.pos)
      self.assertEqual(list(self.at.z), list(at.z))

   def testwrite_multi_xyz_properties(self):
      self.al.write('test.xyz', properties=['species','pos'], format='pupyxyz')
      al = AtomsList('test.xyz', format='pupyxyz')
      for at,at_ref in zip(al, self.al):
         self.assertEqual(sorted(at.properties.keys()), sorted(['species', 'pos', 'Z']))
         self.assertArrayAlmostEqual(at.pos, at_ref.pos)
         self.assertEqual(list(at.z), list(at_ref.z))

if __name__ == '__main__':
   unittest.main()
