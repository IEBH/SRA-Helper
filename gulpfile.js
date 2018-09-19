var {spawn} = require('child_process');
var gulp = require('gulp');
var gutil = require('gulp-util');
var path = require('path');
var preprocess = require('gulp-preprocess');
var rename = require('gulp-rename');
var temp = require('temp');

/**
* Setup preprocess to work with AutoIt files (.au3)
*/
gulp.task('configure:preprocess', ()=> {
	var ppRules = require('./node_modules/preprocess/lib/regexrules');
	ppRules.au3 = {
		echo: ";[ \t]*@echo[ \t]+(.*?)[ \t]*",
		exec: ";[ \t]*@exec[ \t]+(\\S+)[ \t]*\\((.*)\\)[ \t]*",
		include: "(.*);[ \t]*@include(?!-)[ \t]+(.*?)[ \t]*",
		'include-static': "(.*);[ \t]*@include-static[ \t]+(.*?)[ \t]*",
		if: {
			start: "[ \t]*;[ \t]*@(ifndef|ifdef|if)[ \t]+(.+)(?:[ \t]*\n+)?",
			end: "[ \t]*;[ \t]*@endif(?:[ \t]*\n)?",
		},
	};
});


/**
* Run AutoIt in test mode - compiles a temp file and immediately runs it
*/
gulp.task('test', ['configure:preprocess'], ()=> {
	var tempFile = temp.path({prefix: 'SRA-Helper', suffix: 'au3'});

	return gulp.src('./src/SRA-Helper.au3')
		.pipe(preprocess({context: {BOND: true}}))
		.pipe(rename(path.basename(tempFile)))
		.pipe(gulp.dest(path.dirname(tempFile)))
		.on('end', ()=> {
			gutil.log('Temp file:', tempFile);
			spawn('wine', ['autoit/AutoIt3.exe', tempFile], {
				cwd: `${__dirname}/src`,
			});
		})
})


/**
* Build all available versions
*/
gulp.task('build', ['build:bond', 'build:monash']);

/**
* Compile SRA-Helper in Bond University mode
*/
gulp.task('build:bond', ['configure:preprocess'], ()=> {
	var tempFile = temp.path({prefix: 'SRA-Helper', suffix: 'au3'});

	return gulp.src('./src/SRA-Helper.au3')
		.pipe(preprocess({context: {BOND: true}}))
		.pipe(rename(path.basename(tempFile)))
		.pipe(gulp.dest(path.dirname(tempFile)))
		.on('end', ()=> {
			gutil.log('Temp file:', tempFile);
			spawn('wine', [
				'autoit\\Aut2Exe\\Aut2exe.exe',
				'/in',
				tempFile,
				'/out',
				'..\\builds\\SRA-Helper-Bond.exe',
				'/icon',
				'SRA-Helper.ico',
				'/pack'
			], {
				cwd: `${__dirname}/src`,
			});
		})
});


/**
* Compile SRA-Helper in Monash University mode
*/
gulp.task('build:monash', ['configure:preprocess'], ()=> {
	var tempFile = temp.path({prefix: 'SRA-Helper', suffix: 'au3'});

	return gulp.src('./src/SRA-Helper.au3')
		.pipe(preprocess({context: {MONASH: true}}))
		.pipe(rename(path.basename(tempFile)))
		.pipe(gulp.dest(path.dirname(tempFile)))
		.on('end', ()=> {
			gutil.log('Temp file:', tempFile);
			spawn('wine', [
				'autoit\\Aut2Exe\\Aut2exe.exe',
				'/in',
				tempFile,
				'/out',
				'..\\builds\\SRA-Helper-Monash.exe',
				'/icon',
				'SRA-Helper.ico',
				'/pack'
			], {
				cwd: `${__dirname}/src`,
			});
		})
});
