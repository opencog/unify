
IF (CXXTEST_FOUND)
	INCLUDE(AddCxxtest)

	ADD_DEFINITIONS(-DPROJECT_SOURCE_DIR="${CMAKE_SOURCE_DIR}"
	                -DPROJECT_BINARY_DIR="${CMAKE_BINARY_DIR}")

	ADD_SUBDIRECTORY(unifier)
ENDIF (CXXTEST_FOUND)

# All tests should load the unify scm from the build dir, unless the scm
# file is specific to the test (this variable is used by ADD_GUILE_TEST)
SET(GUILE_LOAD_PATH "${PROJECT_BINARY_DIR}")

ADD_SUBDIRECTORY(atoms)

#	IF (HAVE_CYTHON AND HAVE_NOSETESTS)
#		MESSAGE(STATUS "found cython and nosetest, enabling python unit tests")
#		ADD_SUBDIRECTORY (cython)
#	ENDIF (HAVE_CYTHON AND HAVE_NOSETESTS)
