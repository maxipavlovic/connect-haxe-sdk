package connect;


/**
    Represents the default LoggerWriter. The `Logger` uses an instance of this class
    to write log messages (by default to the standard output and the given filename).

    The filename can be null if you do not want to write messages to a persistent file.
**/
class LoggerWriter {
    public function new() {
        this.filename = null;
        this.file = null;
    }


    /**
        Sets the filename of the log file if it has not been previously set.
    **/
    public function setFilename(filename: String): Void {
        if (this.filename == null) {
            this.filename = filename;
        }
    }


    /** @returns The filename of the log file. **/
    public function getFilename(): String {
        return this.filename;
    }


    /** Writes a line to the log output. The line feed character is added by the method. **/
    public function writeLine(line: String): Void {
        if (this.getFile() != null) {
            this.getFile().writeString(line + '\r\n');
        }
        Sys.println(line);
    }


    private var filename: String;
    private var file: sys.io.FileOutput;


    private function getFile(): sys.io.FileOutput {
        if (this.file == null && this.filename != null) {
            this.file = sys.io.File.append(this.filename);
        }
        return this.file;
    }
}