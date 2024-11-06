const express = require('express');
const wkhtmltopdf = require('wkhtmltopdf');
const {execFile} = require('child_process');

const app = express();

// Endpoint to generate the 
app.get('/generate-pdf', (req, res) => {
    	
    // Check if wkhtmltopdf is installed
    execFile('wkhtmltopdf', ['--version'], error => {
        if (error && error.code === 'ENOENT') {
            console.error('wkhtmltopdf not found. Please ensure it is installed and accessible in the PATH.');
            // Optionally, set a flag or notify about the unavailability of wkhtmltopdf
            return res
                .status(500)
                .json({message: 'wkhtmltopdf is not available. Please install it to enable PDF generation.'});
        }
    });

    // Create a PDF from HTML
    wkhtmltopdf(`<h1>Hello, PDF!</h1><p>This is a test PDF file generated from HTML.</p>`).pipe(res).on('error',(err)=>{
        console.error(err)
    });
    
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
