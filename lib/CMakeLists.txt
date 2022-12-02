# build_type is used in UnifyConfig.cmake.in
string(TOUPPER "${CMAKE_BUILD_TYPE}" build_type )

export(EXPORT UnifyTargets
	FILE "${CMAKE_CURRENT_BINARY_DIR}/Unify/UnifyTargets.cmake"
)

set(ConfigPackageLocation lib/cmake/Unify)

install(EXPORT UnifyTargets
	FILE UnifyTargets.cmake
	DESTINATION ${ConfigPackageLocation}
)

include(CMakePackageConfigHelpers)

configure_package_config_file(UnifyConfig.cmake.in
	${CMAKE_CURRENT_BINARY_DIR}/UnifyConfig.cmake
	INSTALL_DESTINATION lib/Unify/cmake
	PATH_VARS CMAKE_INSTALL_PREFIX
)

write_basic_package_version_file(
	"${CMAKE_CURRENT_BINARY_DIR}/UnifyConfigVersion.cmake"
	VERSION ${SEMANTIC_VERSION}
	COMPATIBILITY SameMajorVersion
)

INSTALL(FILES
	${CMAKE_CURRENT_BINARY_DIR}/UnifyConfigVersion.cmake
	${CMAKE_CURRENT_BINARY_DIR}/UnifyConfig.cmake
	DESTINATION ${ConfigPackageLocation}
)
