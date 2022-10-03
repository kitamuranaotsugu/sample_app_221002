class List < ApplicationRecord
    has_one_attached :image
#画像を読み込ませて表示したいが、他のカラムと違って、activestorageを用いて導入するには、migrationファイルにimageカラムを記述するのではなく、追加したいモデルにhas_one_attachedメソッドでimageカラムを追加する
#has_one_attachedメソッドはモデルが取り込むレコード１件につき１つのみ画像を紐付けるというメソッドです
    validates :title, presence: true
    validates :body, presence: true
    validates :image, presence: true
#validatesメソッドは第１引数としてシンボルの形でカラム名を記述し、第２引数として第１引数の存在についてtrueを返すように設定しています。（つまり、第１引数が存在していなければ第２引数はfalseとなり、はじかれる。）
end
