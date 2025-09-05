import React from 'react';
import { Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper } from '@mui/material';

const TablaRanking = ({ data, modalidad }) => {
  return (
    <TableContainer component={Paper}>
      <Table sx={{bgcolor: '#506C64', border: 'solid 2px white', width: '350px', height: '500px'}}>
        <TableHead>
          <TableRow>
            <TableCell sx={{color: 'white', fontWeight: 'bold', fontSize: '1.3rem'}}>
              Puesto
            </TableCell>
            <TableCell
              sx={{
                bgcolor: '#ff8e0d',
                borderRadius: '8px',
                fontFamily: '"Anta", sans-serif',
                fontSize: '3rem',
                textAlign: 'center'
              }}
            >
              {modalidad}
            </TableCell>
            <TableCell sx={{color: 'white', fontWeight: 'bold', fontSize: '1.3rem'}}>
              Elo
            </TableCell>
          </TableRow> 
        </TableHead>
        
        <TableBody>
          {data.map((item, index) => (
            <TableRow key={index}>
              <TableCell 
                  component="th" scope="row"
                  sx={{color: 'white', fontWeight: '800', fontSize: '1.3rem'}}
                >
                #{index + 1}
              </TableCell>
              <TableCell
                  sx={{color: 'white', fontWeight: 'bold', fontSize: '1.3rem'}}
                >
                {item.nombre}</TableCell>
              <TableCell
                sx={{color: 'white', fontWeight: 'bold', fontSize: '1.3rem'}}
              >
                {item.elo}</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
};

export default TablaRanking;