class ESCOJIDALaEntidaQuery < EasyQuery

  self.queried_class = ESCOJIDALaEntida

  def initialize_available_filters
    add_available_filter 'name', name: ::ESCOJIDALaEntida.human_attribute_name(:name), type: :string
    add_available_filter 'created_at', name: ::ESCOJIDALaEntida.human_attribute_name(:created_at), type: :date
    add_available_filter 'updated_at', name: ::ESCOJIDALaEntida.human_attribute_name(:updated_at), type: :date

  end

  def available_columns
    return @available_columns if @available_columns
    group = l("label_filter_group_#{self.class.name.underscore}")

    add_available_column 'name', caption: ::ESCOJIDALaEntida.human_attribute_name(:name), title: ::ESCOJIDALaEntida.human_attribute_name(:name), group: group
    add_available_column 'created_at', caption: ::ESCOJIDALaEntida.human_attribute_name(:created_at), title: ::ESCOJIDALaEntida.human_attribute_name(:created_at), group: group
    add_available_column 'updated_at', caption: ::ESCOJIDALaEntida.human_attribute_name(:updated_at), title: ::ESCOJIDALaEntida.human_attribute_name(:updated_at), group: group

    @available_columns
  end

  def default_list_columns
    super.presence || ["name", "created_at", "updated_at"].flat_map{|c| [c.to_s, c.to_sym]}
  end

  def default_columns_names
    super.presence || ["name", "created_at", "updated_at"].flat_map{|c| [c.to_s, c.to_sym]}
  end
end
