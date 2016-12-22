pragma solidity ^0.4.0;

contract EthDb {

  bytes32[][] tbl;
  bytes32[] tableNames;
  bytes32[] tblTemp;
  mapping (bytes32 => bytes32[][]) tables;

  // Create table
  function createTable (bytes32 tableName, bytes32[] schema, bytes32[] dataTypes) {
    for (uint i = 0; i < tableNames.length; i++) {
      if (tableName == tableNames[i]) {
        return;
      }
    }
    tableNames.push(tableName);
    tables[tableName].push(schema);
    tables[tableName].push(dataTypes);
  }

  // Read full table
  function readTable (bytes32 tableName) returns (bytes32[]) {
    tables[tableName];
    for (uint i = 0; i < tables[tableName].length; i++) {
      for (uint j = 0; j < tables[tableName][i].length; j++) {
        tblTemp.push(tables[tableName][i][j]);
      }
    }
    return tblTemp;
  }

  function getTableNames () returns (bytes32[]) {
    return tableNames;
  }

  // Create row on table
  function createRow (bytes32 tableName, bytes32[] newRow) {
    if (tables[tableName].length == 0) { return; }
    tables[tableName].push(newRow);
  }

  // Get table's width
  function getTblWidth (bytes32 tableName) returns (uint) {
    return tables[tableName][0].length;
  }

  // Update the Table
  function updateTable (bytes32 tableName, bytes32 searchColName, bytes32 searchVal, bytes32 colName, bytes32 value) {
    int8 searchIndex = -1;
    int8 changeIndex = -1;

    for (uint i = 0; i < tables[tableName][0].length; i++) {
    if (tables[tableName][0][i] == searchColName) {
        searchIndex = int8(i);
      }
    if(tables[tableName][0][i] == colName) {
        changeIndex = int8(i);
      }
    }
   if (searchIndex == -1 || changeIndex == -1) { return; }

    for (uint j = 1; j < tables[tableName].length; j++) {
    if (tables[tableName][j][uint(searchIndex)] == searchVal) {
    tables[tableName][j][uint(changeIndex)] = value;
      }
    }
  }

  // Remove row
  function removeRow(bytes32 tableName, bytes32 searchColName, bytes32 searchVal) {
    int8 columnIndex = -1;

    for (uint i = 0; i < tables[tableName][0].length; i++) {
      if (tables[tableName][0][i] == searchColName) {
        columnIndex = int8(i);
      }
    }
    if (columnIndex == -1) return;

    for(uint j = 1; j < tables[tableName].length; j++) {
      if(tables[tableName][j][uint(columnIndex)] == searchVal) {
        removeRowHelper(tableName, j);
        j--;
      }
    }
  }

  // Helper remove row
  function removeRowHelper(bytes32 tableName, uint index)  returns(uint[]) {
    if (index >= tables[tableName].length) return;

    for (uint i = index; i<tables[tableName].length-1; i++){
      tables[tableName][i] = tables[tableName][i+1];
    }
    delete tables[tableName][tables[tableName].length-1];
    tables[tableName].length--;
  }

  //Search Table
  function searchTable(bytes32 tableName, bytes32 colName, bytes32 value) returns(bytes32[]) {
    int8 index = -1;

    for (uint i = 0; i < tables[tableName][0].length; i++) {
      if (tables[tableName][0][i] == colName) {
        index = int8(i);
      }
    }

    if (index == -1) { return; }

    for (uint j = 1; j < tables[tableName].length; j++) {
      if (tables[tableName][j][uint(index)] == value) {
        for (uint k = 0; k < tables[tableName][j].length; k++) {
          tblTemp.push(tables[tableName][j][k]);
        }
      }
    }

    return tblTemp;
  }

}