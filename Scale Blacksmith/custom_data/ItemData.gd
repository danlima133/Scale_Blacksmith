extends Resource
class_name MetaItem

enum words {
	word_1,
	word_2,
	word_3
}

export(Texture) var icon
export(String) var name_item
export(String , MULTILINE) var item_descripition
export(Array , words) var test
export(int) var item_count
