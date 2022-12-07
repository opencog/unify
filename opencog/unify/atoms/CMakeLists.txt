
# The atom_types.h file is written to the build directory
INCLUDE_DIRECTORIES(${CMAKE_BINARY_DIR})

ADD_LIBRARY (unify-atoms
	UnifierLink.cc
	UnifyReduceLink.cc
)

# Without this, parallel make will race and crap up the generated files.
ADD_DEPENDENCIES(unify-atoms unify_atom_types)

TARGET_LINK_LIBRARIES(unify-atoms
	unify-types
	unify
	${ATOMSPACE_LIBRARIES}
	${COGUTIL_LIBRARY}
)

INSTALL (TARGETS unify-atoms EXPORT AtomSpaceTargets
   DESTINATION "lib${LIB_DIR_SUFFIX}/opencog"
)

INSTALL (FILES
	UnifierLink.h
	UnifyReduceLink.h
	DESTINATION "include/opencog/atoms/unify"
)

# Bogus boiler-plate generator for unit testing.
ADD_GUILE_EXTENSION(SCM_CONFIG unify-atoms "opencog-ext-path-unify-atoms")
