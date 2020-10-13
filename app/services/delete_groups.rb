class DeleteGroups
  require 'rufus-scheduler'
  require 'date'

  def self.flush
    scheduler = Rufus::Scheduler.new
    day = Date.today.strftime("%Y/%m/%d")
    scheduler.every '3s' do
      p "Group destroy"
    end
    scheduler.join
  end
end
