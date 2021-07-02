import os
import unittest
import tempfile
from filecmp import dircmp

from src.phylogeny_generation import PhylogenyGenerator, PhylogenyGeneratorError, MSAError


class TestPhylogenyGenerator(unittest.TestCase):
    def test_basic_regression(self):
        """
        Test that PhylogenyGenerator runs and its output matches the expected output.
        The expected output is located at test_input_data/trees_small .

        We run the same PhylogenyGenerator twice: first without caching,
        then with caching, to make sure that caching works.
        """
        with tempfile.TemporaryDirectory() as root_dir:
            outdir = os.path.join(root_dir, 'trees')
            for use_cached in [False, True]:
                phylogeny_generator = PhylogenyGenerator(
                    a3m_dir='test_input_data/a3m_small',
                    n_process=3,
                    expected_number_of_MSAs=3,
                    outdir=outdir,
                    max_seqs=8,
                    max_sites=16,
                    max_families=3,
                    rate_matrix='None',
                    use_cached=use_cached,
                )
                phylogeny_generator.run()
                dcmp = dircmp(outdir, 'test_input_data/trees_small')
                diff_files = dcmp.diff_files
                assert(len(diff_files) == 0)

    def test_custom_rate_matrix_runs_regression(self):
        """
        Tests the use of a custom rate matrix in FastTree.
        """
        with tempfile.TemporaryDirectory() as root_dir:
            outdir = os.path.join(root_dir, 'trees')
            phylogeny_generator = PhylogenyGenerator(
                a3m_dir='test_input_data/a3m_small',
                n_process=3,
                expected_number_of_MSAs=3,
                outdir=outdir,
                max_seqs=8,
                max_sites=16,
                max_families=3,
                rate_matrix='input_data/synthetic_rate_matrices/Q1_uniform_FastTree.txt',
                use_cached=False,
            )
            phylogeny_generator.run()
            dcmp = dircmp(outdir, 'test_input_data/trees_small_Q1_uniform')
            diff_files = dcmp.diff_files
            assert(len(diff_files) == 0)

    def test_inexistent_rate_matrix_raises_error(self):
        """
        If the rate matrix passed to FastTree does not exist, we should error out.
        """
        with tempfile.TemporaryDirectory() as root_dir:
            outdir = os.path.join(root_dir, 'trees')
            phylogeny_generator = PhylogenyGenerator(
                a3m_dir='test_input_data/a3m_small',
                n_process=3,
                expected_number_of_MSAs=3,
                outdir=outdir,
                max_seqs=8,
                max_sites=16,
                max_families=3,
                rate_matrix='I-do-not-exist',
                use_cached=False,
            )
            with self.assertRaises(PhylogenyGeneratorError):
                phylogeny_generator.run()

    def test_malformed_a3m_file_raises_error(self):
        """
        If the a3m data is corrupted, an error should be raised.
        """
        with tempfile.TemporaryDirectory() as root_dir:
            outdir = os.path.join(root_dir, 'trees')
            phylogeny_generator = PhylogenyGenerator(
                a3m_dir='test_input_data/a3m_small_corrupted',
                n_process=3,
                expected_number_of_MSAs=3,
                outdir=outdir,
                max_seqs=8,
                max_sites=16,
                max_families=3,
                rate_matrix='None',
                use_cached=False,
            )
            with self.assertRaises(MSAError):
                phylogeny_generator.run()
