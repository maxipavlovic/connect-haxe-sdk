package connect.native;


#if java
class JavaIterator<T> implements java.util.Iterator<T> {
    public function new(array: Array<T>) {
        this.array = array;
        this.index = 0;
    }

    public function hasNext(): Bool {
        return index < this.array.length;
    }


    public function next(): T {
        return this.array[this.index++];
    }


    public function remove(): Void {
        // Not implemented
    }


    private final array: Array<T>;
    private var index: Int;
}
#end
