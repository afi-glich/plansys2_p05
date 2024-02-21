#include <memory>
#include <algorithm>

#include "plansys2_executor/ActionExecutorClient.hpp"

#include "rclcpp/rclcpp.hpp"

using namespace std::chrono_literals;

class MoveCarrier : public plansys2::ActionExecutorClient
{
public:
  MoveCarrier()
  : plansys2::ActionExecutorClient("move-carrier", 1s)
  {
    progress_ = 0.0;
  }

private:
    void do_work()
    {
        if (progress_ < 1.0) {
        progress_ += 0.05;
        send_feedback(progress_, "MoveCarrier running");
        } else {
        finish(true, 1.0, "MoveCarrier completed");
    
        progress_ = 0.0;
        std::cout << std::endl;
        }
    
        std::cout << "\r\e[K" << std::flush;
        std::cout << "Moving carrier ... [" << std::min(100.0, progress_ * 100.0) << "%]  " <<
        std::flush;
    }
    
    float progress_;
};

int main(int argc, char ** argv)
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<MoveCarrier>();

    node->set_parameter(rclcpp::Parameter("action_name", "move-carrier"));
    node->trigger_transition(lifecycle_msgs::msg::Transition::TRANSITION_CONFIGURE);

    rclcpp::spin(node->get_node_base_interface());

    rclcpp::shutdown();

    return 0;
}