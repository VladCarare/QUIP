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
import unittest, quippy
from quippytest import *

if hasattr(quippy, 'Potential'):

   class TestMD(QuippyTestCase):

      def setUp(self):
         verbosity_push(PRINT_SILENT)
         system_reseed_rng(1)
         s = supercell(diamond(5.44, 14), 2, 2, 2)
         s.set_cutoff(5.0)
         s.calc_connect()

         xml="""
         <SW_params n_types="2" label="PRB_31_plus_H">
         <comment> Stillinger and Weber, Phys. Rev. B  31 p 5262 (1984), extended for other elements </comment>
         <per_type_data type="1" atomic_num="1" />
         <per_type_data type="2" atomic_num="14" />
         <per_pair_data atnum_i="1" atnum_j="1" AA="0.0" BB="0.0"
               p="0" q="0" a="1.0" sigma="1.0" eps="0.0" />
         <per_pair_data atnum_i="1" atnum_j="14" AA="8.581214" BB="0.0327827"
               p="4" q="0" a="1.25" sigma="2.537884" eps="2.1672" />
         <per_pair_data atnum_i="14" atnum_j="14" AA="7.049556277" BB="0.6022245584"
               p="4" q="0" a="1.80" sigma="2.0951" eps="2.1675" />

         <!-- triplet terms: atnum_c is the center atom, neighbours j and k -->
         <per_triplet_data atnum_c="1"  atnum_j="1"  atnum_k="1"
               lambda="21.0" gamma="1.20" eps="2.1675" />
         <per_triplet_data atnum_c="1"  atnum_j="1"  atnum_k="14"
               lambda="21.0" gamma="1.20" eps="2.1675" />
         <per_triplet_data atnum_c="1"  atnum_j="14" atnum_k="14"
               lambda="21.0" gamma="1.20" eps="2.1675" />

         <per_triplet_data atnum_c="14" atnum_j="1"  atnum_k="1"
               lambda="21.0" gamma="1.20" eps="2.1675" />
         <per_triplet_data atnum_c="14" atnum_j="1"  atnum_k="14"
               lambda="21.0" gamma="1.20" eps="2.1675" />
         <per_triplet_data atnum_c="14" atnum_j="14" atnum_k="14"
               lambda="21.0" gamma="1.20" eps="2.1675" />
         </SW_params>
         """

         pot = Potential('IP SW', xml)

         ds = DynamicalSystem(s)
         ds.rescale_velo(300.0)
         ds.zero_momentum()

         self.al = AtomsList(ds.run(pot, dt=1.0, n_steps=10, save_interval=1))
         list(self.al)
         verbosity_pop()

         self.pos_ref = FortranArray([[ -4.90754401e-02,   4.66043499e-02,  -2.93596981e-02],
                                      [  1.32173068e+00,   1.36049715e+00,   1.34487476e+00],
                                      [  2.74041495e+00,   2.69789411e+00,   3.85250084e-02],
                                      [  4.07785210e+00,   4.04142606e+00,   1.37866220e+00],
                                      [  2.71968483e+00,   4.24598801e-02,   2.68967819e+00],
                                      [  4.05517759e+00,   1.31991379e+00,   4.10060988e+00],
                                      [ -4.35328803e-02,   2.71989350e+00,   2.71199442e+00],
                                      [  1.37658088e+00,   4.06937268e+00,   4.06946097e+00],
                                      [  1.72131649e-02,  -2.22276153e-02,  -5.43278679e+00],
                                      [  1.39841983e+00,   1.39921745e+00,  -4.10832771e+00],
                                      [  2.71204485e+00,   2.72442171e+00,  -5.43041944e+00],
                                      [  4.08018209e+00,   4.07574609e+00,  -4.04670921e+00],
                                      [  2.75045850e+00,   4.05919334e-02,  -2.71053627e+00],
                                      [  4.03933883e+00,   1.32118811e+00,  -1.31575502e+00],
                                      [ -3.93219747e-02,   2.74132720e+00,  -2.71106791e+00],
                                      [  1.36274051e+00,   4.10474770e+00,  -1.38772491e+00],
                                      [  1.39064378e-02,  -5.41205973e+00,   4.58066722e-02],
                                      [  1.31413233e+00,  -4.11238821e+00,   1.35538108e+00],
                                      [  2.70719005e+00,  -2.76738728e+00,  -2.88560899e-02],
                                      [  4.03740686e+00,  -1.34443027e+00,   1.36721176e+00],
                                      [  2.71299199e+00,  -5.40642190e+00,   2.69901495e+00],
                                      [  4.09710213e+00,  -4.06989108e+00,   4.08274306e+00],
                                      [  8.14918540e-03,  -2.69652349e+00,   2.72127963e+00],
                                      [  1.40167907e+00,  -1.33782081e+00,   4.12304532e+00],
                                      [  3.24444100e-02,  -5.39568659e+00,   5.40824632e+00],
                                      [  1.36219647e+00,  -4.04407417e+00,  -4.10536668e+00],
                                      [  2.68518664e+00,  -2.74483665e+00,   5.42609124e+00],
                                      [  4.08996402e+00,  -1.38023787e+00,  -4.06457459e+00],
                                      [  2.71247579e+00,   5.42916615e+00,  -2.75338746e+00],
                                      [  4.09826927e+00,  -4.07990661e+00,  -1.34783450e+00],
                                      [  3.91182895e-02,  -2.70981898e+00,  -2.70338255e+00],
                                      [  1.38522531e+00,  -1.32478293e+00,  -1.32882989e+00],
                                      [  5.41657401e+00,  -1.04869330e-02,  -1.95805453e-02],
                                      [ -4.12171332e+00,   1.38941400e+00,   1.35657495e+00],
                                      [ -2.70023174e+00,   2.69754667e+00,  -9.03932210e-03],
                                      [ -1.37700437e+00,   4.07165728e+00,   1.33380553e+00],
                                      [ -2.71105517e+00,   4.27565934e-03,   2.68145422e+00],
                                      [ -1.33609265e+00,   1.35447734e+00,   4.11940180e+00],
                                      [ -5.39822705e+00,   2.69688261e+00,   2.71832604e+00],
                                      [ -4.09305297e+00,   4.04893335e+00,   4.04892554e+00],
                                      [  5.41666741e+00,  -3.31208852e-02,  -5.39306711e+00],
                                      [ -4.03434830e+00,   1.36796006e+00,  -4.08885523e+00],
                                      [ -2.69776403e+00,   2.74844139e+00,   5.40767822e+00],
                                      [ -1.33348863e+00,   4.03811722e+00,  -4.04664744e+00],
                                      [ -2.70931548e+00,   1.52111243e-03,  -2.75395628e+00],
                                      [ -1.40209669e+00,   1.35995404e+00,  -1.39231254e+00],
                                      [ -5.42696911e+00,   2.75917700e+00,  -2.75388086e+00],
                                      [ -4.04299895e+00,   4.10263236e+00,  -1.37015886e+00],
                                      [  5.41917451e+00,  -5.43705824e+00,  -1.96774464e-02],
                                      [ -4.08809521e+00,  -4.04337099e+00,   1.32919066e+00],
                                      [ -2.69498132e+00,  -2.70618081e+00,   2.93377715e-02],
                                      [ -1.36012833e+00,  -1.32689075e+00,   1.35745182e+00],
                                      [ -2.74733815e+00,   5.40738984e+00,   2.70542072e+00],
                                      [ -1.38098650e+00,  -4.10831964e+00,   4.07428074e+00],
                                      [  5.42529199e+00,  -2.69900139e+00,   2.75015386e+00],
                                      [ -4.10854709e+00,  -1.39523912e+00,   4.12522927e+00],
                                      [  5.43897204e+00,   5.39940539e+00,  -5.42399389e+00],
                                      [ -4.04266526e+00,  -4.10392036e+00,  -4.10237846e+00],
                                      [ -2.68115720e+00,  -2.76821419e+00,  -5.42052938e+00],
                                      [ -1.39819883e+00,  -1.37064426e+00,  -4.03911828e+00],
                                      [ -2.67860243e+00,   5.39639791e+00,  -2.74035172e+00],
                                      [ -1.35799456e+00,  -4.06115050e+00,  -1.32339519e+00],
                                      [ -5.43645975e+00,  -2.68322199e+00,  -2.72114819e+00],
                                      [ -4.09451361e+00,  -1.38333685e+00,  -1.35684712e+00]])

         self.force_ref = FortranArray([[ 0.42472337, -0.47643683,  0.12329161],
                                        [-0.02411012,  0.26483767,  0.1490756 ],
                                        [-0.87104692,  0.39491896, -0.61809466],
                                        [ 0.33401719,  0.63922079,  0.03515913],
                                        [-0.52680272, -0.48051087,  0.45094111],
                                        [ 0.65205081,  0.6554571 , -0.10009954],
                                        [ 0.51689286,  0.05570492,  0.16280328],
                                        [-0.26390535,  0.28426533, -0.25576162],
                                        [-0.16478328,  0.2134844 ,  0.68010906],
                                        [-0.95450009, -0.48307374,  0.83093265],
                                        [ 0.64683104,  0.29357275, -0.3579274 ],
                                        [-0.23692867, -0.00420403, -0.77779591],
                                        [-0.55425286, -0.66439153, -0.40675514],
                                        [ 1.11683662,  1.21848042, -0.78549072],
                                        [ 1.08610067, -0.77780384,  0.09355336],
                                        [-0.02975855, -0.38528736,  0.87345813],
                                        [-0.58750721, -0.85675798, -1.07211835],
                                        [ 0.80390994,  1.07214914,  0.37103767],
                                        [-0.10178354,  0.49154225,  0.7972756 ],
                                        [ 0.34264327, -0.51428302, -0.33194838],
                                        [ 0.26870632, -0.59656463,  0.28882489],
                                        [-0.30134349, -0.4276699 ,  0.17952043],
                                        [-0.13037182, -0.0499062 ,  0.32600945],
                                        [-0.40706885, -0.07146565, -1.09393257],
                                        [-0.44126023, -1.00116347,  0.57432841],
                                        [-0.08654789, -0.55854651,  0.46569591],
                                        [ 1.15153192,  0.49290056,  0.27840502],
                                        [-0.86748768,  0.0473108 , -0.07862845],
                                        [ 0.1778634 ,  0.76080362,  0.37267876],
                                        [-0.3501288 , -0.10118749, -0.93092327],
                                        [-0.45735244,  0.1991439 ,  0.21190668],
                                        [-0.25373933,  0.00829764, -0.4243377 ],
                                        [ 0.19799787, -0.14737893,  0.56406751],
                                        [ 0.79899705, -0.84144439, -0.58249766],
                                        [-0.68779818,  0.29956215, -0.0568988 ],
                                        [ 0.12637833,  0.13769501,  0.26284662],
                                        [-0.68270835,  0.1550025 ,  1.11377789],
                                        [-0.36408704, -0.25511652, -0.72214541],
                                        [-1.34716583, -0.09218536,  0.4807947 ],
                                        [ 0.16633408,  0.41249721,  0.49211128],
                                        [ 0.46188504,  0.48638488, -0.32117084],
                                        [-0.62689261,  0.16924933, -0.34369425],
                                        [-0.06869379, -0.34672227,  0.45217722],
                                        [ 0.04576042,  1.04692573, -1.41197226],
                                        [-0.73748339, -0.21380414,  0.80274222],
                                        [ 0.33135584,  0.10464131, -0.02848057],
                                        [ 0.00436203, -1.07725772,  1.13149623],
                                        [-0.3939541 , -0.37814423,  0.15637916],
                                        [ 0.44167906, -0.33337854,  0.46726513],
                                        [-0.22307198, -0.47923511,  0.62772507],
                                        [-0.35106397,  0.21197447, -0.40462914],
                                        [ 0.35314085, -0.24033609, -0.0818485 ],
                                        [-0.01447384,  0.47327962, -0.28055804],
                                        [ 0.36969479,  0.26916106, -0.53748228],
                                        [-0.00295301, -0.09339267, -0.67542057],
                                        [ 0.89650201,  0.51165207, -0.28978935],
                                        [ 0.08989896,  0.33737863, -0.36420957],
                                        [-0.53295372, -0.053076  ,  0.64613886],
                                        [-0.48532917,  0.55153092, -0.26932028],
                                        [ 1.12999474, -0.22504948, -0.616119  ],
                                        [-0.02880659,  0.89325784,  0.41422251],
                                        [ 0.27184971, -0.33271999, -0.51574738],
                                        [ 0.3102599 , -1.20934911, -0.1315671 ],
                                        [ 0.63991727,  0.61556059, -0.00938646]])

      def testpos(self):
         self.assertArrayAlmostEqual(self.al[-1].pos, self.pos_ref)

      def testforce(self):
         self.assertArrayAlmostEqual(self.al[-1].force, self.force_ref)


if __name__ == '__main__':
   unittest.main()



