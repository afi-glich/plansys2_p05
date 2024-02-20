import os;

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument, IncludeLaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node

def generate_launch_description():
    # Get the launch directory
    example_dir = get_package_share_directory('plansys2_p5')
    namespace = LaunchConfiguration('namespace')

    declare_namespace_cmd = DeclareLaunchArgument(
        'namespace',
        default_value='',
        description='Namespace')

    plansys2_cmd = IncludeLaunchDescription(
        PythonLaunchDescriptionSource(os.path.join(
            get_package_share_directory('plansys2_bringup'),
            'launch',
            'plansys2_bringup_launch_monolithic.py')),
        launch_arguments={
          'model_file': example_dir + '/pddl/p5_domain.pddl',
          'namespace': namespace
          }.items())

    # Specify the actions
    delivery_cmd = Node(
        package='plansys2_p5',
        executable='deliver_action_node',
        name='deliver_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])
    
    empty_box_cmd = Node(
        package='plansys2_p5',
        executable='empty_box_action_node',
        name='empty_box_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])
    
    fill_box_cmd = Node(
        package='plansys2_p5',
        executable='fill_box_action_node',
        name='fill_box_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])
    
    move_cmd = Node(
        package='plansys2_p5',
        executable='move_action_node',
        name='move_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])
    
    load_cmd = Node(
        package='plansys2_p5',
        executable='load_action_node',
        name='load_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])
    
    unload_cmd = Node(
        package='plansys2_p5',
        executable='unload_action_node',
        name='unload_action_node',
        namespace=namespace,
        output='screen',
        parameters=[])
    
    # Create the launch description and populate
    ld = LaunchDescription()
    ld.add_action(declare_namespace_cmd)

    # Declare the launch options
    ld.add_action(plansys2_cmd)

    ld.add_action(delivery_cmd)
    ld.add_action(empty_box_cmd)
    ld.add_action(fill_box_cmd)
    ld.add_action(move_cmd)
    ld.add_action(load_cmd)
    ld.add_action(unload_cmd)
    return ld