ENABLE_TESTING()
INCLUDE(AddCxxtest)

ADD_DEFINITIONS(-DPROJECT_SOURCE_DIR="${CMAKE_SOURCE_DIR}"
                -DPROJECT_BINARY_DIR="${CMAKE_BINARY_DIR}")

# All tests should load the unify scm from the build dir, unless the scm
# file is specific to the test (this variable is used by ADD_CXXTEST)
SET(GUILE_LOAD_PATH "${PROJECT_BINARY_DIR}/opencog/unify/scm")

IF (CXXTEST_FOUND)

	ADD_SUBDIRECTORY (unify)

#	IF (HAVE_CYTHON AND HAVE_NOSETESTS)
#		MESSAGE(STATUS "found cython and nosetest, enabling python unit tests")
#		ADD_SUBDIRECTORY (cython)
#	ENDIF (HAVE_CYTHON AND HAVE_NOSETESTS)

ENDIF (CXXTEST_FOUND)
