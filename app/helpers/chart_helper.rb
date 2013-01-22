module ChartHelper
  def graph_users_relations(kinships)
    g = GraphViz::new('chart', type: 'graph', rankdir: 'LR', splines: 'ortho', smoothing: 'triangle')

    g.node['fillcolor'] = '#f5f5f5'
    g.node['color'] = '#999999'
    g.node['style'] = 'filled,rounded'
    g.node['shape'] = 'box'
    g.node['fontname'] = 'sans'
    g.node['fontsize'] = '10'
    g.node['fontcolor'] = '#333333'
    g.node['penwidth'] = '1.0'

    g.edge['fontname'] = 'sans'
    g.edge['fontsize'] = '6'
    g.edge['fontcolor'] = '#999999'
    g.edge['color'] = '#0088cc'
    g.edge['penwidth'] = '2.0'

    kinships.each do |k|
      parent_node = g.get_node(k.relative_id.to_s) || node_for_user(g, k.relative)
      child_node  = g.get_node(k.user_id.to_s) || node_for_user(g, k.user)

      g.add_edges parent_node, child_node
    end

    save_graph_as_image(g)
  end

  private

  def node_for_user(graph, user)
    job = user.jobs.in_institution(current_institution).first
    name_row = %{<TR><TD>#{user}<br/><font point-size="6">#{job.description || ' '}</font></TD></TR>}
    image_row = %{<TR><TD><IMG SRC="#{user.avatar.micro_thumb.path}"/></TD></TR>} if user.avatar?
    label = %{<<TABLE border="0" cellborder="0">#{image_row}#{name_row}</TABLE>>}

    graph.add_nodes(user.id.to_s, label: label)
  end

  def save_graph_as_image(graph)
    tmp_dir = "#{Rails.root}/tmp/charts"
    tmp_file = "#{tmp_dir}/graph_#{Time.now.to_i}_#{rand(1000)}.png"

    FileUtils.mkdir_p tmp_dir

    graph.output(png: tmp_file)

    public_dir = "#{Rails.root}/public/system/charts/#{current_institution.identification}"
    file = "chart-#{Digest::MD5.hexdigest(File.read(tmp_file))}.png"
    dimensions = MiniMagick::Image.open(tmp_file)['dimensions']

    FileUtils.mkdir_p public_dir
    FileUtils.mv tmp_file, "#{public_dir}/#{file}"

    image_tag "/system/charts/#{current_institution.identification}/#{file}", size: dimensions.join('x'), alt: @title
  end
end
