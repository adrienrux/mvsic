# Wrapper class for easy read/write access to Mailchimp's API

class Mailchimp

  def initialize(api_key)
    @gb = Gibbon::API.new(api_key)
  end

  # Lists
  def lists
    @gb.lists.list
  end

  # Members of a list
  # Defaults to the prelaunch list
  def members(list_id = prelaunch_id)
    @gb.lists.members(id: list_id)
  end

  # Subscribe a member to a list
  # Defaults to the prelaunch list
  def subscribe(list_id = prelaunch_id, email)
    @gb.lists.subscribe(
      id: list_id,
      email: {
        email: email
      },
      merge_vars: {},
      double_optin: false
    )
  end

  # ID of the prelaunch list
  def prelaunch_id
    lists["data"].find { |list| list['name'] == 'MVSIC Prelaunch' }['id']
  end


end
