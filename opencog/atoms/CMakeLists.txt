
# guile unit-test boilerplate crud
DECLARE_GUILE_CONFIG_TARGET(SCM_CONFIG "opencog unify-config" "UNIFY_TEST")

ADD_SUBDIRECTORY (unify_types)
ADD_SUBDIRECTORY (rule)
ADD_SUBDIRECTORY (scm)

# Extension language support
#IF (HAVE_CYTHON)
#	ADD_SUBDIRECTORY (cython)
#ENDIF (HAVE_CYTHON)
