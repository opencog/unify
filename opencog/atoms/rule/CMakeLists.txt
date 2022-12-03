
# The atom_types.h file is written to the build directory
INCLUDE_DIRECTORIES(${CMAKE_BINARY_DIR})

ADD_LIBRARY (unify-rules
	RuleLink.cc
)

# Without this, parallel make will race and crap up the generated files.
ADD_DEPENDENCIES(unify-rules unify_atom_types)

TARGET_LINK_LIBRARIES(unify-rules
	unify-types
	unify
	${ATOMSPACE_LIBRARIES}
	${COGUTIL_LIBRARY}
)

INSTALL (TARGETS unify-rules EXPORT AtomSpaceTargets
   DESTINATION "lib${LIB_DIR_SUFFIX}/opencog"
)

INSTALL (FILES
	RuleLink.h
	DESTINATION "include/opencog/atoms/rule"
)
