#include <memory>
#include <algorithm>

#include "plansys2_executor/ActionExecutorClient.hpp"

#include "rclcpp/rclcpp.hpp"
#include "rclcpp_action/rclcpp_action.hpp"

using namespace std::chrono_literals;

class DeliverBox : public plansys2::ActionExecutorClient
{
public:
  DeliverBox()
  : plansys2::ActionExecutorClient("deliver_box", 1s)
  {
    progress_ = 0.0;
  }

private:
    void do_work()
    {
        if (progress_ < 1.0) {
        progress_ += 0.05;
        send_feedback(progress_, "DeliverBox running");
        } else {
        finish(true, 1.0, "DeliverBox completed");
    
        progress_ = 0.0;
        std::cout << std::endl;
        }
    
        std::cout << "\r\e[K" << std::flush;
        std::cout << "Delivering box at workstation ... [" << std::min(100.0, progress_ * 100.0) << "%]  " <<
        std::flush;
    }
    
    float progress_;
};

int main(int argc, char ** argv)
{
    rclcpp::init(argc, argv);
    auto node = std::make_shared<DeliverBox>();

    node->set_parameter(rclcpp::Parameter("action_name", "deliver_box"));
    node->trigger_transition(lifecycle_msgs::msg::Transition::TRANSITION_CONFIGURE);

    rclcpp::spin(node->get_node_base_interface());

    rclcpp::shutdown();

    return 0;
}