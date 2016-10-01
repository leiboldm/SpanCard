<?php
class DatabaseWrapper {
	public $dbpassword = 'abc123abc123';
	public $dbname = "mattleib_spancard";
	public $dbuser = "mattleib_matt";
	public $host = "localhost";
	public function __construct() {
		$this->dbconn = pg_connect("host=".$this->host." dbname=".$this->dbname." user=".$this->dbuser." password=".$this->dbpassword)
    		or die('Could not connect: ' . pg_last_error());
	}

	public function get_users() {
		$query = 'SELECT * FROM users';
		return $this->exec_query($query);
	}

	public function exec_query($query, $params = []) {
		$result = pg_query_params($this->dbconn, $query, $params) or die('Query failed: ' . pg_last_error());
		$data = [];
		while ($row = pg_fetch_object($result)) {
			array_push($data, $row);
		}
		pg_free_result($result);
		return $data;
	}

	public function insert($table_name, $data) {
		return pg_insert($this->dbconn, $table_name, $data);
	}

	public function __destruct() {
		pg_close($this->dbconn);
	}
}

?>