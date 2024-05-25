module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return unless current_user&.admin?

    edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
    del = button_to('Destroy', item, method: :delete, class: "btn btn-danger", form: { data: { turbo_confirm: "Are you sure ?" } })

    raw("#{edit} #{del}")
  end

  def round(value)
    number_with_precision(value, precision: 1)
  end
end
