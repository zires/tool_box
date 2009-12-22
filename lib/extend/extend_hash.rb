# author :zshuaibin
# date :2009-12-1
#add some useful methods to hash
module	Box
	module	InstanceMethods
		
	# delete a key from hash
		def delete_key(hkey)
			self.reject{|key,value| key == hkey }
		end
		
	# !
		def delete_key!(hkey)
			self.delete_if{|key,value| key == hkey }
		end
		
	# delete some keys from hash	will	return a new hash
	#	eg:
	#	h = {"a"=>100,"b" => 200,"c"=>300}
	#	h.delete_keys("a","d")  #=> {"b" => 200 ,"c" => 300}
	#	attention: h.delete_keys(["a"],["b"]) will return a wrong rusult
		def delete_keys!(*keys)
			if keys.size == 1
				keys = keys[0]
			end
			arr = []
			keys.each do |hkey|
			arr << delete_key!(hkey)
			end
			temp = {}
			arr.each do |arr|
			temp.merge!(arr)
			end
			return temp
		end
		
	#	cut a hash from another hash	will	return a new hash
	#	eg:
	#	{"a" => 100, "b" => 200, "c" => 300}.cut! {"b" => 300, "c" => 300} #=> {"a" =>100}
	#	or .cut! "a" #=> {"b" => 200, "c" => 300}
	#	or .cut!	{"d" => 300}	#=>	{"a" => 100, "b" => 200, "c" => 300}
	# 	or .cut! ["a","b"]	#=> {"c" => 300}
		def cut!(arg)
			return self if arg.empty?
			if arg.instance_of?	String
				delete_key!(arg)
			elsif arg.instance_of? Array
				delete_keys!(arg)
			elsif arg.instance_of? Hash
				a = []
				arg.each_key {|key| a << key }
				delete_keys!(a)
			else
				raise ArgumentError,"wrong argument"
			end
		end
		
	#	draw out a hash from an exist hash
	#	eg:
	#	{"a" => 100, "b" => 200}.draw_out("a") #=> {"a" => 100 }
	#	or .draw_out(["a","b","c"]) #=> {"a" => 100, "b" => 200}
		def draw_out(arg)
			arg = arg.to_a
			size = arg.size
			arr = Array.new(size){Hash.new}
			size.times do |i|
				arr[i][arg[i]] = self.fetch(arg[i],"nil")
			end
			temp = {}
			arr.each do |arr|
				temp.merge!(arr)
			end
			# temp.invert
			temp.delete_if {|key,value| value == "nil"}
		end
		
		
		
	end #InstanceMethods
end	#Box

# class Hash
class	Hash
	include	Box::InstanceMethods
end