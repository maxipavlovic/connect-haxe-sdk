package connect;


@:dox(hide)
class StepData {
    public final firstIndex: Int;
    public final input: Dynamic;
    public final data: Dictionary;

    public function new(firstIndex: Int, input: Dynamic, data: Dynamic) {
        this.firstIndex = firstIndex;
        this.input = input;
        this.data = new Dictionary();
        if (Std.is(data, Dictionary)) {
            // Store model class names with key
            for (key in cast(data, Dictionary).keys()) {
                final value = data.get(key);
                final className = Std.is(value, connect.models.Model)
                    ? Type.getClassName(Type.getClass(value))
                    : '';
                this.data.set('$key::$className', value);
            }
        } else {
            // For keys that have an attached class name, parse class
            for (field in Reflect.fields(data)) {
                final fieldSplit = field.split('::');
                final fieldName = fieldSplit.slice(0, -1).join('::');
                final fieldClass = fieldSplit.slice(-1)[0];
                final value = Reflect.field(data, field);
                final parsedValue = (fieldClass != '')
                    ? connect.models.Model.parse(Type.resolveClass(fieldClass), value)
                    : value;
                this.data.set(fieldName, parsedValue);
            }
        }
    }
}