# frozen_string_literal: true

module Components::CalendarHelper
  def render_calendar(date: Date.today, events: [], **options, &block)
    @date = date
    @events = events
    @options = options
    content = capture(&block) if block
    render 'components/ui/calendar', date:, events:, content:, **options
  end

  def render_controls(&block)
    content_for :calendar_controls, capture(&block), flush: true
  end

  def render_event(day)
    events_for_day = @events.select { |event| (event.start.to_date..event.end.to_date).include?(day) }

    events_for_day.map do |event|
      render_button(event.service.title,
                    as: :link,
                    href: service_path(event.service.id),
                    variant: :outline)
    end.join.html_safe
  end

  private

  def weeks
    first = @date.beginning_of_month.beginning_of_week(:sunday)
    last = @date.end_of_month.end_of_week(:sunday)
    (first..last).to_a.in_groups_of(7)
  end

  def day_classes(day)
    classes = ['h-full w-full flex flex-col border-l p-2 overflow-hidden hover:bg-muted/50 hover:cursor-pointer']
    classes << 'bg-primary' if day == Date.today
    classes << 'bg-secondary' if day.month != @date.month
    classes.empty? ? nil : classes.join(' ')
  end
end
