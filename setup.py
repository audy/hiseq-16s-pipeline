from setuptools import setup

from hiseq_pipe import __version__

setup(
    name='hiseq-16s-pipeline',
    version=__version__.string,
    author='Austin G. Davis-Richardson',
    author_email='harekrishna@gmail.com',
    packages=['hiseq_pipe', 'hiseq_pipe.tests'],
    url='',
    license='LICENSE.txt',
    description='Pipeline for 16S rRNA amplicon analysis',
    test_suite='hiseq_pipe.tests.get_suite',
    entry_points = {
        'console_scripts': [
            'hp = hiseq_pipe.__main__:main'
        ]
    }
)
