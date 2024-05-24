module Components::AvatarHelper
  def render_avatar(src: nil, data: {}, **options)
    avatar_classes = 'relative flex h-8 w-8 shrink-0 overflow-hidden rounded-full hover:shadow-lg'
    avatar_classes << " #{options[:class]}"
    avatar_classes = tw(avatar_classes)
    render 'components/ui/avatar', avatar_classes:, src:, data:, **options
  end
end
