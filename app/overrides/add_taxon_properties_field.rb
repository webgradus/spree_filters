Deface::Override.new(:virtual_path => "spree/admin/taxons/_form",
                     :insert_after => 'erb[loud]:contains("f.field_container :icon")',
                     :text => '<%= f.field_container :property_ids do %>
                     <%= f.label :property_ids, Spree.t(:properties) %><br>
                     <%= f.select :property_ids, @taxon.get_properties("").uniq.map{|e| [e.presentation, e.id]}, {}, {:class => "select2 fullwidth", :multiple => true} %>
                      <% end %>',
                     :name => "add_taxon_properties_field")
