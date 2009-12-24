# author :zeroath
# date :2009-12-1
# add some view_helpers
require 'action_view/helpers/tag_helper'
require 'extend/extend_hash'

module	ToolHelpers
		
		#	-- link has image src --
		#	image_link(src,url,image_options=nil,href_options=nil)
		# just like link_to && image_tag 
		#	eg:
		# image_link("image.jpg",{:controller => 'photo',:action => 'show'},{:width => '90'})
		#	#=> <a href="/photo/show/id"><image src="images/image.jpg" width='90'></a>
		def image_link(src,url,*args)
			src = image_path(src)
			hurl = url_for(url)
			image_options = args.first || {}
			href_options = args.second || {}
			href = "href=\"#{hurl}\""
			image_tag = image_tag(src,image_options)

			if href_options.blank?
				tag_options = nil
			else
				href_options = href_options.stringify_keys
				convert_options_to_javascript!(href_options, url)
				tag_options = tag_options(href_options)
			end
			"<a #{href}#{tag_options}>#{image_tag}</a>"
		end
		
# ************************************************************************************
		# args include caption col colgroup thead tfoot tbody and table_html_options
		# eg: table_for(:caption => "caption",)
		$table_compages = [:caption,:col,:colgroup]
		def table_for(*args,&proc)
			raise ArgumentError,"Need block" unless block_given?
			options = args.extract_options!
			compages_options = options.draw_out($table_compages)
			table_html_options = options.cut!(compages_options)
			content = capture(&proc)
			concat(tag(:table,table_html_options,true))
			if compages_options.has_key?(:caption)
				caption = compages_options.delete(:caption)
				concat("\n<caption>#{caption}</caption>")
				compages_options.delete_key!(:caption)
			else
				compages_options
			end
				compages_options.each_key do |key|
				skey = key.to_s
				concat "\n"
				concat(tag(key,{:id => skey},true))
				concat("</"+ skey + ">")
			end
			concat(content)
			concat('</table>')
		end
		
		# <% t_tr do %>
		#	<%= t_th("head")%>
		#	<%= t_td('haha',:id => "haha")%>
		# <% end %>
		#	##=>  <tr>
		#			<th>head</th>
		#			<td>haha</td></tr>
		#
		def t_tr(options = {},&block)
			concat(tag("tr",options,true))
			yield
			concat("</tr>")
		end
		
		# easy way!
		# <%= tr(2,:class => "haha",["one","two",true],["o","t"])%> #=>
		#	<tr class="haha">
		#		<th>one</th>
		#		<th>two</th>
		#	</tr>
		#	<tr class="haha">
		#		<td>o</td>
		#		<td>t</td>
		#	</tr>
		#
		def tr(row,options = {},*arrays)
			raise ArgumentError,"row must be Integer" unless row.is_a? Integer
			row.times do |i|
				concat(tag("tr",options,true) + "\n")
				if arrays[i].last == true
          num = arrays[i].size - 1
					array = arrays[i][0...num]
					array.each do |tcontent|
						concat(eval("t_th(tcontent)"))
						concat("\n")
					end
				else
					arrays[i].each do |tcontent|
						concat(eval("t_td(tcontent)"))
						concat("\n")
					end
				end
				concat("</tr>")
			end
		end
		def t_th(tcontent,options = {})
			create_tag("th",tcontent,options)
		end

		def t_td(tcontent,options = {})
			create_tag("td",tcontent,options)
		end

		def t_thead(options = {},&block)
			concat(tag('thead',options,true))
			yield
			concat('</thead>')
		end

		def t_tbody(options = {},&block)
			concat(tag('tbody',options,true))
			yield
			concat('</tbody>')
		end

		def t_tfoot(options = {},&block)
			concat(tag('tfoot',options,true))
			yield
			concat('</tfoot>')
		end
		
		
		def create_tag(tag_type,tcontent,options)
			if tcontent.instance_of? String
				tcontent ||= ""
			else
				raise ArgumentError,"the value of column must be string"
			end
			tag(tag_type,options,true) +
			"\n" + tcontent +
			"</#{tag_type}>"
		end
		
#******************************************************************************************
		#def self.include(base)
			#base.extend	ClassMethods
		#end
	
		#def ClassMethods
			#include	ActionView::ToolHelpers::InstanceMethods
			#extend	ActionView::ToolHelpers::SinletonMethods
		#end
		
		#	class methods
		#def SingletonMethods
			
		#end
		
		#	instance methods
		#def InstanceMethods
			
		#end
	
	
	
	
end