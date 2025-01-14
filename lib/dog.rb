class Dog

    attr_accessor :name , :breed
    attr_reader :id

    def initialize(id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def self.create_table
        sql = <<-SQL
            CREATE TABLE dogs (
                id INTEGER PRIMARY KEY,
                name TEXT,
                breed TEXT
            )
            SQL
        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = <<-SQL
        DROP TABLE dogs
        SQL

        DB[:conn].execute(sql)
    end

    def save
        sql = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?)
            SQL
        
        DB[:conn].execute(sql,self.name,self.breed)[0]
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end

    def self.create (name:, breed:)
        new_dog = self.new(name: name,breed: breed)
        new_dog.save
        new_dog
    end

    def self.new_from_db(row)
        id = row[0]
        name = row[1]
        breed = row[2]
        self.new(id: id, name: name, breed: breed)
    end

    def self.all
        sql = <<-SQL
            SELECT *
            FROM dogs
            SQL

        DB[:conn].execute(sql).map do |row|
            self.new_from_db(row)
        end
    end

    def self.find_by_name(name)
        sql = <<-SQL
            SELECT * FROM
            dogs
            WHERE name = ?
            LIMIT 1
            SQL

        DB[:conn].execute(sql, name).map do |row|
            self.new_from_db(row)
        end[0]
    end

    def self.find(id_num)
        sql = <<-SQL
            SELECT * FROM
            dogs
            WHERE id = ?
            LIMIT 1
            SQL

        DB[:conn].execute(sql, id_num).map do |row|
            self.new_from_db(row)
        end[0]
    end

end
