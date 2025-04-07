module ProjectsHelper
  def status_class(status)
    case status.to_sym
    when :planning
      "bg-yellow-100 text-yellow-800 py-1 px-2 rounded-full text-xs font-medium"
    when :in_progress
      "bg-blue-100 text-blue-800 py-1 px-2 rounded-full text-xs font-medium"
    when :in_review
      "bg-indigo-100 text-indigo-800 py-1 px-2 rounded-full text-xs font-medium"
    when :completed
      "bg-green-100 text-green-800 py-1 px-2 rounded-full text-xs font-medium"
    else
      "bg-gray-100 text-gray-800 py-1 px-2 rounded-full text-xs font-medium"
    end
  end
end
