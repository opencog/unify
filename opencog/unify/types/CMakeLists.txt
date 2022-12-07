
OPENCOG_ADD_ATOM_TYPES(unify_types.script
	atom_types.h
	atom_types.definitions
	atom_types.inheritance
	unify_types.scm
	unify_types.pyx
)
ADD_CUSTOM_TARGET(unify_atom_types DEPENDS atom_types.h)

# The atom_types.h file is written to the build directory
INCLUDE_DIRECTORIES(${CMAKE_BINARY_DIR})

ADD_LIBRARY (unify-types SHARED
	unify_types_init.cc
)

# Without this, parallel make will race and crap up the generated files.
ADD_DEPENDENCIES(unify-types unify_atom_types)

TARGET_LINK_LIBRARIES(unify-types
	${ATOMSPACE_LIBRARIES}
)

INSTALL (TARGETS unify-types
	LIBRARY DESTINATION "lib${LIB_DIR_SUFFIX}/opencog"
)

ADD_GUILE_EXTENSION(SCM_CONFIG unify-types "opencog-ext-path-unify")

INSTALL (FILES
	${CMAKE_CURRENT_BINARY_DIR}/atom_types.h
	DESTINATION "include/opencog/unify/types"
)

INSTALL (FILES
	${CMAKE_CURRENT_BINARY_DIR}/unify_types.scm
	DESTINATION "${GUILE_SITE_DIR}/opencog/unify/types"
)
