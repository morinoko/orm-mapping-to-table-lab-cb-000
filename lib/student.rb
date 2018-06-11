class Student
  # Database can be accessed with DB[:conn]
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql_insert = <<-SQL
      INSERT INTO students (name, grade) VALUES (?, ?);
    SQL

    DB[:conn].execute(sql_insert, @name, @grade)

    sql_last_id = <<-SQL
      SELECT last_insert_rowid() FROM students;
    SQL

    @id = DB[:conn].execute(sql_last_id)[0][0]
  end

  def self.create(name:, grade:)
    # Can use tap to return the student object for us
    student = Student.new(name, grade).tap { |student| student.save }

    # condensed version
    # student = Student.new(name, grade).tap(&:save)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students;
    SQL

    DB[:conn].execute(sql)
  end
end
