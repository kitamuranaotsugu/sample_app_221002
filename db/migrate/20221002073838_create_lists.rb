class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.string :title
      t.string :body
# テーブル内のブロック変数としてt(tableの略)を指定し、tをカラムとしてドットでつなぎカラムの型を指定し、シンボル＝：xxx（メソッド等のキーになるオブジェクト）でカラムの中身を記述することでカラムが定義される
      t.timestamps
    end
  end
end
