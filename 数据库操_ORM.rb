#!/opt/ruby_2.5.1/bin/ruby
# coding: utf-8
#
#  https://ruby-china.github.io/rails-guides/active_record_basics.html
#
require 'active_record'


ActiveRecord::Base.establish_connection(:adapter => "mysql2",  
                                        :username => "root",  
                                        :password => "",  
                                        :database => "active_record",  
                                        :host => "127.0.0.1")




  
class CreateCeshi < ActiveRecord::Migration[5.2]
  def create
    create_table :ceshi , {:id => false } do |t|
    #默认会创建id字段，并当作主键
    t.integer :uid , null: false , :options => 'PRIMARY KEY'
    t.string :name , null: true
    t.text :description
    t.string :col1
    t.string :col2
    t.string :col3
    #如下代码，会创建，created_at 和 updated_at 的字段，字段类型是 datetime
    #t.timestamps
    end
  end
  
  def remove_change
    change_table :ceshi do |t|
      t.remove :col1, :col2
    end  
  end

  def rename_change
    change_table :ceshi do |t|
      t.rename :col3,:col4
    end
  end

  def create_index
    change_table :ceshi do |t|
      t.index :name
    end
  end

  def add_col
    add_column :ceshi , :col5 , :string , null: false
    add_column :ceshi , :col6 , :string , default: "Y" , comment: "测试字段"
    add_column :ceshi , :col7 , :decimal , precision: 10 , scale: 2
    add_column :ceshi , :col8 , :string , limit: 128
  end

  def change_col
    change_column :ceshi , :col8 , :integer
    change_column_null :ceshi, :col5, true
    change_column_default :ceshi , :col6 , from: "Y" , to: "N"
  end

  def change_index
    add_index :ceshi , :col8
    add_index :ceshi , [:col7 , :col6]  #多列索引
    remove_index :ceshi , :name
  end

  def remove_change2
    remove_column :ceshi , :col8
  end

  def rename_change2
    rename_column :ceshi , :col7 , :col7_new
  end

  def change_table2
    rename_table :ceshi , :ceshi2
    rename_table :ceshi2 , :ceshi
  end

  def del
    drop_table :ceshi
  end
end

=begin
class Ceshi < ActiveRecord::Base
  self.primary_key = "uid"
end
=end



begin
  CreateCeshi.new.del
rescue Exception => e
  nil
end
CreateCeshi.new.create
CreateCeshi.new.remove_change
CreateCeshi.new.rename_change
CreateCeshi.new.create_index
CreateCeshi.new.add_col
CreateCeshi.new.change_col
CreateCeshi.new.change_index
CreateCeshi.new.remove_change2
CreateCeshi.new.rename_change2
CreateCeshi.new.change_table2


class Ceshi < ActiveRecord::Base
  self.table_name = "ceshi"  #如果不设置这个，你默认的表名就是 类名+s，如果你的数据库没有这个表会报错
  self.primary_key = "uid"  #如果你不设置name为主键，那么你删除的时候，destory会报错。
end


#如果 Active Record 提供的辅助方法不够用，可以使用 excute 方法执行任意 SQL 语句：
a=Ceshi.new
a.uid=1
a.name='wxl'
a.description='desc'
a.col4='a'
a.col5='a'
a.col6='a'
a.col7_new=1.22
a.save
查询=Ceshi.connection.execute("select * from ceshi")
查询.each {|x|
  p x
}
exit


#
# 删,注意，这里操作的列，请务必是主键，如果不是主键，你的语句会报错，如果你强制该字段为主键，你可能会发生同时删除多行的可能
# 

删除项目=Ceshi.where(name: "wxl").order(name: "desc");
删除项目.each {|x|
   x
  #x.destroy
}

exit

#
# 增
#

200.times {|x|
  a=Ceshi.new
  a.id=x
  a.name="wxl"
  a.save
}


# 查
所有 = Ceshi.all
所有.each {|x|
  p x
}
第一个=Ceshi.first
p 第一个

#返回第一个满足条件的
wxl=Ceshi.find_by(name: "wxl") 

#筛查
puts "-------------------1"
满足条件=Ceshi.where(name: "wxl").order(name: "desc");
p 满足条件


#查找 主键 是 wxl 的条目，缺省是id，代码里面定义是name
查询=Ceshi.find("wxl")

p 查询

#take 方法检索一条记录而不考虑排序
查询=Ceshi.take 3

#排序
查询=Ceshi.order(:name).first
查询=Ceshi.order(:name).last
#

#批量检索多个对象
#
# 这种方法在数据量特别大的情况下，占用多大的内存
#
Ceshi.all.each {|x|
  #p x
}

# 处理大量数据的第一种优化办法,start选项用于配置想要取回的记录序列的第一个 ID，比这个 ID 小的记录都不会取回。这个选项有时候很有用，例如当需要恢复之前中断的批处理时，只需从最后一个取回的记录之后开始继续处理即可
Ceshi.find_each(start: 5,finish: 100,batch_size: 10) {|x|
  p x
}




