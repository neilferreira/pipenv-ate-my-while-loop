""" Project installation configuration """

from setuptools import find_packages, setup


setup(
    name="lambda-1",
    packages=find_packages("src"),
    package_dir={"": "src"},
    install_requires=[],
)
