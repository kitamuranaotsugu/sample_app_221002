class ListsController < ApplicationController
  def new
    @list = List.new
#viewページでフォームに表示するインスタンスとしてインスタンス変数を定義する。内容は、Listモデルに対して、フォームに入力するための空のインスタンスを生成するメソッドであるnew（デフォルトである）を利用
  end

  def create
    @list = List.new(list_params)
#Listモデルに対して、デフォルトで存在するnewメソッドを呼び出すことでデータを格納する空のインスタンスを作り出すのだが、今回はoptionでlist_paramsを利用してtitleとbodyのデータをインスタンス変数に格納する
#renderメソッド実装後は、エラーメッセージをview(new.html.erb)上で表示する必要がある（なぜ登録に失敗したのか入力者に知らせるため）。
#ここで、renderメソッドはルーティング（HTTPメソッド+url出決まるHTTPリクエストに基づいたアクションの実行）を伴わないため、createアクション内にインスタンス変数を記述せねばならない。
    if @list.save
#作られたtitleとbodyのデータを格納したインスタンスをデータベースに保存する（後のvalidationが適用されるのはココ）
#ターミナル上で入力されたデータをコントローラーが受け取り、begin transaction → createアクションの実行 List Create, Insert Into 'Lists'... → commint transactionと表示されるか見る。
      redirect_to list_path(@list.id)
#データが保存（commit transaction)された場合にはshowページを表示するようパスを設定する。
#redirect_toメソッドは、自分でurlを打ち込んでenterを押すことと同義。パスを送る＝ルーティングを行うことである。
#redirect_toは主にデータの変更（登録、更新、削除）を伴う場合に用いるが、これはデータの変更を行うアクション(create,update,destroy)と更新後にviewを表示させるアクションおよびviewページ(showやindex)が異なるため。
#renderの場合、データは変更されず、元のデータを表示するだけであり、元々のアクションを引き続き行いたい（また、元のviewページを表示したい）ため、新しいアクションが不要となる。これによりredirect_toと区別する。
    else
      render :new
#この記述はredirect_toのパスとして、保存が成功し、レコードが登録された際のidが必要となるため、validation実装後は保存失敗時にUrlGenerationErrorが出てしまう（:id => nil, missing parameter required [:id]が出る）
    end
  end

  def show
    @list = List.find(params[:id])
#Listモデルに対し、デフォルトとして持っているfindメソッドによって検索をかける。findメソッドの引数として、params(=レコード全体が対象)の内、idをキーとしているため、urlのidと合致するidのレコードが格納される。
#つまり、今回の@listというインスタンス変数は、listsテーブルの内の、シンボルとしてのid(:id)でurlから絞り込まれた１件のレコードを、Listモデルのインスタンスに格納したインスタンス変数(@list)である
  end

  def index
    @lists = List.all
#Listモデルに対して、DBに保存された全データを表示するメソッドであるall（デフォルト）を利用してlistsテーブルにある全データを呼び出す。その際、データを格納する変数に@listsというインスタンス変数を利用
  end

  def edit
    @list = List.find(params[:id])
#Listモデルに対し、デフォルトとして持っているfindメソッドによって検索をかける。findメソッドの引数として、params(=レコード全体が対象)の内、idをキーとしているため、urlのidと合致するidのレコードが格納される。
#つまり、今回の@listというインスタンス変数は、listsテーブルの内の、シンボルとしてのid(:id)でurlから絞り込まれた１件のレコードを、Listモデルのインスタンスに格納したインスタンス変数(@list)である
  end

  def update
    @list = List.find(params[:id])
#今回は空ではなく、どのレコードを更新するのか選定する必要があるため、findメソッドの引数をparamsメソッドの引数として:idにして、urlの:idと合致するレコードをテーブル全体から絞り込む。（インスタンスのセット）
    if @list.update(list_params)
#Listモデルのインスタンスであるlistに対して、updateメソッドを使って更新するのだが、対象（引数）はlist_paramsでparamsメソッドで取得した全データからpermitメソッドによりlistモデルに絞り、更に該当するidの
# レコードのtitleおよびbodyカラムに入力されたデータのみ変更が許可されて、updateメソッドの引数として渡され、そこでvalidationをくぐり抜けたデータだけが更新を許可される。
      redirect_to list_path(@list.id)
    else
      render :edit
    end
  end

  def destroy
    list = List.find(params[:id])
    list.destroy
    redirect_to lists_path
#レコードを取得してインスタンス（オブジェクト）に格納した後、そのオブジェクトをdestroyメソッドにより消去し、redirect_toメソッドでindexページに遷移する
  end

private
#普通のアクションとして定義するとurlが作られ、外部からアクセスできてしまう＝マスアサインメント脆弱性→privateの記述でlistsコントローラー中でしか呼び出せないよう制限した。
#params＝送られてきた全てのデータ（オブジェクトからデータだけ取り出せる！）を取得するメソッド、requireでListモデルに格納されたデータのみを対象に絞る、permitでtitleおよびbodyカラムのみ保存を許可する。
  def list_params
    params.require(:list).permit(:title,:body, :image)
  end

end
