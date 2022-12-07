# Bogus boilerplate for unit-testing. This should be automated.
# This must come first, befoe any other build targets.
DECLARE_GUILE_CONFIG_TARGET(SCM_CONFIG "opencog unify-config" "UNIFY_TEST")

ADD_SUBDIRECTORY (types)
ADD_SUBDIRECTORY (atoms)
ADD_SUBDIRECTORY (scm)

ADD_LIBRARY (unify
	Unify.cc
)

TARGET_LINK_LIBRARIES(unify
	${ATOMSPACE_LIBRARIES}
	${COGUTIL_LIBRARY}
)

INSTALL (TARGETS unify
    EXPORT UnifyTargets
    DESTINATION "lib${LIB_DIR_SUFFIX}/opencog")

INSTALL (FILES
	Unify.h
	DESTINATION "include/opencog/unify"
)
