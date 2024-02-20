cmake_minimum_required(VERSION 3.5)
project(plansys2_p05)

find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(plansys2_msgs REQUIRED)
find_package(plansys2_executor REQUIRED)

set(CMAKE_CXX_STANDARD 17)

set(dependencies
    rclcpp
    plansys2_msgs
    plansys2_executor
)

add_executable(deliver_box_action_node src/deliver_box_action_node.cpp)
ament_target_dependencies(deliver_box_action_node ${dependencies})

add_executable(fill_box_action_node src/fill_box_action_node.cpp)
ament_target_dependencies(fill_box_action_node ${dependencies})

add_executable(load_box_action_node src/load_box_action_node.cpp)
ament_target_dependencies(load_box_action_node ${dependencies})

add_executable(move_action_node src/move_action_node.cpp)
ament_target_dependencies(move_action_node ${dependencies})

add_executable(empty_box_action_node src/empty_box_action_node.cpp)
ament_target_dependencies(empty_box_action_node ${dependencies})

add_executable(unload_box_action_node src/unload_box_action_node.cpp)
ament_target_dependencies(unload_box_action_node ${dependencies})

install(DIRECTORY launch pddl DESTINATION share/${PROJECT_NAME})

install(TARGETS
    deliver_box_action_node
    fill_box_action_node
    load_box_action_node
    move_action_node
    empty_box_action_node
    unload_box_action_node
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION lib/${PROJECT_NAME}
)

if(BUILD_TESTING)
    find_package(ament_lint_auto REQUIRED)
    ament_lint_auto_find_test_dependencies()

    find_package(ament_cmake_gtest REQUIRED)
endif()

ament_export_dependencies($d{dependencies})

ament_package()

