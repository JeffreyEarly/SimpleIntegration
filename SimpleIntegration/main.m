//
//  main.m
//  SimpleIntegration
//
//  Created by Jeffrey J. Early on 3/12/15.
//  Copyright (c) 2015 Jeffrey J. Early. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLNumericalModelingKit/GLNumericalModelingKit.h>

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		
		GLEquation *equation = [[GLEquation alloc] init];
		GLDimension *tDim = [[GLDimension alloc] initDimensionWithGrid:kGLEndpointGrid nPoints:300 domainMin:0.0 length:300.0];
		
		GLFloat Q = 108.3333;
		GLFloat Vol1 = 150;
		GLFloat Vol2 = 44;
		GLFloat IT = 25;
		
		GLFunction *Ci = [GLFunction functionOfRealTypeWithDimensions: @[tDim] forEquation:equation];
		Ci = [Ci setValue: 1.0 atIndices: @"0:25"];
		Ci = [Ci times: @((350/IT)*2)];
		
		GLFloat PS = Q;
		
//		GLDimension *veinsDim = [[GLDimension alloc] initDimensionWithGrid: kGLEndpointGrid nPoints:1 domainMin:0 length:0];
		GLFunction *Civ0 = [GLFunction functionOfRealTypeWithDimensions: @[] forEquation:equation];
		GLFunction *Cec0 = [GLFunction functionOfRealTypeWithDimensions: @[] forEquation:equation];
//		Civ0 = [Civ0 setValue: 0.0 atIndices: @":"];
//		Cec0 = [Cec0 setValue: 0.0 atIndices: @":"];
		
		GLAdaptiveRungeKuttaOperation *integrator = [GLAdaptiveRungeKuttaOperation rungeKutta23AdvanceY: @[Civ0, Cec0] stepSize:0.1 fFromTY:^(GLScalar *t, NSArray *yNew) {
			
			GLFunction *Ci_t = [Ci interpolateAtPoints: @[t]];
			GLFunction *Civ_t = yNew[0];
			GLFunction *Cec_t = yNew[1];
			GLFunction *diff = [Civ_t minus: Cec_t];
			
			GLFunction *fCiv = [[[Ci_t minus: Civ_t] minus: [diff times: @(PS/Vol1)]] times: @(Q/Vol1)];
			GLFunction *fCec = [diff times: @(PS/Vol2)];
			
			return @[fCiv, fCec];
		}];
		
		
		
		NSArray *results = [integrator integrateAlongDimension: tDim];
		GLFunction *Civ = results[0];
		GLFunction *Cec = results[1];
		
		[Ci dumpToConsole];
		
		[Civ dumpToConsole];
		[Cec dumpToConsole];
	}
    return 0;
}
