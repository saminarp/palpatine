if(ENABLE_CLANG_TIDY)
    if(CMake_SOURCE_DIR STREQUAL CMake_BINARY_DIR)
        message(FATAL_ERROR "🔴 CMake_RUN_CLANG_TIDY requires an out-of-source build!")
    endif()
    find_program(CLANG_TIDY_COMMAND NAMES clang-tidy)
    if(NOT CLANG_TIDY_COMMAND)
        message(WARNING "🔴 CMake_RUN_CLANG_TIDY is ON but clang-tidy is not found!")
        set(CMAKE_CXX_CLANG_TIDY "" CACHE STRING "" FORCE)
    else()
        message(STATUS "🟢 CMake_RUN_CLANG_TIDY is ON")
        set(CLANGTIDY_EXTRA_ARGS
            "-extra-arg=-Wno-unknown-warning-option"
        )
        
        set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_COMMAND};-p=${CMAKE_BINARY_DIR};${CLANGTIDY_EXTRA_ARGS}" CACHE STRING "" FORCE)
        set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

        add_custom_target(clang-tidy
            COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target ${CMAKE_PROJECT_NAME}
            COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target clang-tidy
            COMMENT "Running clang-tidy..."
        )

        set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
        
    endif()
endif()
