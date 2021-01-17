

var myString = "Hello, World!"
 
print(myString)

import Cocoa

for ch in "Hello" {
	print(ch)
}


class Counter{

	var count = 0

	func increatment(){
		count += 1
	}
    func incrementBy(amount: Int) {
        count += amount
    }
    func reset() {
        count = 0
    }

}

let counter = Counter()

counter.increatment()

counter.incrementBy(amount: 5)
print(counter.count)
