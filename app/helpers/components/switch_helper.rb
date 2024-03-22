module Components::SwitchHelper
  def render_switch(text, id:, name:, state: "unchecked", controller: "ui--switch", action: "click->ui--switch#toggle", **options)
    render "components/ui/switch", text:, id:, name:, state:, controller:, action:, options:
  end
end
