set(KIRIGAMI2_ENABLED off CACHE BOOL "Build kirigami.")

    if(KIRIGAMI2_ENABLED)
    include(ExternalProject)

    set(KIRIGAMI2_BRANCH master CACHE STRING "The git branch to use.")
    set(KIRIGAMI2_BUILD_SHARED on CACHE BOOL "Build dynamic libs.")

    file(WRITE ${EXTERNAL_PROJECT_BINARY_DIR}/configure.bat
    "
    call \"${CMAKE_BINARY_DIR}/setSearchEnv.bat\"
    cd /D \"${EXTERNAL_PROJECT_BINARY_DIR}/src/KF5Kirigami2-build\"
    \"${CMAKE_COMMAND}\" -G \"${CMAKE_GENERATOR}\" -DCMAKE_INSTALL_PREFIX:PATH=${EXTERNAL_PROJECT_INSTALL_DIR} -DCMAKE_PREFIX_PATH:PATH=${EXTERNAL_CMAKE_PREFIX_PATH} -DCMAKE_CONFIGURATION_TYPES:STRING=${CMAKE_CONFIGURATION_TYPES} -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE} ${EXTERNAL_PROJECT_BINARY_DIR}/src/KF5Kirigami2 
    "
    )

    file(WRITE ${EXTERNAL_PROJECT_BINARY_DIR}/build.bat
    "
    call \"${CMAKE_BINARY_DIR}/setSearchEnv.bat\"
    \"${CMAKE_COMMAND}\" --build ${EXTERNAL_PROJECT_BINARY_DIR}/src/KF5Kirigami2-build --config ${EXTERNAL_PROJECT_BUILD_TYPE}
    "
    )

    file(WRITE ${EXTERNAL_PROJECT_BINARY_DIR}/install.bat
    "
    call \"${CMAKE_BINARY_DIR}/setSearchEnv.bat\"
    \"${CMAKE_COMMAND}\" --build ${EXTERNAL_PROJECT_BINARY_DIR}/src/KF5Kirigami2-build --config ${EXTERNAL_PROJECT_BUILD_TYPE} --target install
    "
    )

    ExternalProject_Add(${EXTERNAL_PROJECT_NAME}
        DEPENDS ECM Qt5
        PREFIX ${EXTERNAL_PROJECT_NAME}
        STAMP_DIR ${CMAKE_BINARY_DIR}/logs
        GIT_REPOSITORY https://github.com/KDE/kirigami.git
        GIT_TAG ${KIRIGAMI2_BRANCH}
        CONFIGURE_COMMAND ${EXTERNAL_PROJECT_BINARY_DIR}/configure.bat
        BUILD_COMMAND ${EXTERNAL_PROJECT_BINARY_DIR}/build.bat
        INSTALL_COMMAND ${EXTERNAL_PROJECT_BINARY_DIR}/install.bat
        LOG_DOWNLOAD 1
        LOG_UPDATE 1
        LOG_CONFIGURE 1
        LOG_BUILD 1
        LOG_TEST 1
        LOG_INSTALL 1
    )

    set(EXTERNAL_QML2_IMPORT_PATH_REL "${EXTERNAL_QML2_IMPORT_PATH_REL};${EXTERNAL_PROJECT_PREFIX}/lib/qml")
endif()