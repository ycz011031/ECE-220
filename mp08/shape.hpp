#ifndef SHAPE_H_
#define SHAPE_H_

#include <iostream>
#include <cmath>
#include <string>
#include <algorithm>
#include <list>
#include <fstream>
#include <iomanip>

using namespace std;

// Base class
// Please implement Shape's member functions
// constructor, getName()
class Shape
{
public:
	// Base class' constructor should be called in derived classes'
	// constructor to initizlize Shape's private variable
	Shape(string name)
	{
		
	    name_=name;
	}

	string getName()
	{
		return name_;
	}

	virtual double getArea() const = 0;
	virtual double getVolume() const = 0;

private:
	string name_;
};

// Rectangle
// Please implement the member functions of Rectangle:
// constructor, getArea(), getVolume(), operator+, operator-

template <class T>
class Rectangle : public Shape
{
public:
	Rectangle(T width, T length) : Shape("Rectangle")
	{
		width_=width;
		length_=length;
	}

	double getArea() const
	{
		return (width_*length_);
	}

	double getVolume() const
	{
		return 0;
	}

	Rectangle operator+(const Rectangle &rec)
	{
		double W,L;
		W =width_+rec.width_;
		L=length_+rec.length_;
		return Rectangle(W,L);
	}

	Rectangle operator-(const Rectangle &rec)
	{
		return Rectangle(max(0.,width_-rec.width_),max(0.,length_-rec.length_));
	}

	T getWidth() const
	{
		return width_;
	}

	T getLength() const
	{
		return length_;
	}

private:
	double width_;
	double length_;
};

// Circle
// Please implement the member functions of Circle:
// constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here

class Circle : public Shape
{
public:
	Circle(double radius) : Shape("Circle")
	{
		radius_ =radius;
	}

	double getArea() const
	{
		return (radius_*radius_*3.1415926);
	}

	double getVolume() const
	{
		return 0;
	}

	Circle operator+(const Circle &cir)
	{
		return Circle(radius_+cir.radius_);
	}

	Circle operator-(const Circle &cir)
	{
		return Circle(max(0.,radius_-cir.radius_));
	}

	double getRadius() const
	{
		return radius_;
	}

private:
	double radius_;
};

// Sphere
// Please implement the member functions of Sphere:
// constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here

class Sphere : public Shape
{
public:
	Sphere(double radius) : Shape("Sphere")
	{
		radius_=radius;
	}

	double getVolume() const
	{
		return (4.0/3.0)*radius_*radius_*radius_*3.1415926;
	}

	double getArea() const
	{
		return 4*radius_*radius_*3.1415926;
	}

	Sphere operator+(const Sphere &sph)
	{
		return Sphere(radius_+sph.radius_);
	}

	Sphere operator-(const Sphere &sph)
	{
		return Sphere(max(0.,radius_-sph.radius_));
	}

	double getRadius() const
	{
		return radius_;
	}

private:
	double radius_;
};

// Rectprism
// Please implement the member functions of RectPrism:
// constructor, getArea(), getVolume(), operator+, operator-
//@@Insert your code here
class RectPrism : public Shape
{
public:
	RectPrism(double width, double length, double height) : Shape("RectPrism")
	{
		width_ = width;
		length_=length;
		height_=height;
	}

	double getVolume() const
	{
		return width_*length_*height_;
	}

	double getArea() const
	{
		return 2*(width_*length_+width_*height_+height_*length_);
	}

	RectPrism operator+(const RectPrism &rectp)
	{
		double L,W,H;
		W=width_+rectp.width_;
		L=length_+rectp.length_;
		H=height_+rectp.height_;
		return RectPrism(W,L,H);
	}

	RectPrism operator-(const RectPrism &rectp)
	{
		double L,W,H;
		W=max(0.,width_-rectp.width_);
		L=max(0.,length_-rectp.length_);
		H=max(0.,height_-rectp.height_);
		return RectPrism(W,L,H);
	}

	double getWidth() const
	{
		return width_;
	}

	double getLength() const
	{
		return length_;
	}

	double getHeight() const
	{
		return height_;
	}

private:
	double length_;
	double width_;
	double height_;
};

// Read shapes from test.txt and initialize the objects
// Return a vector of pointers that points to the objects
static list<Shape *> CreateShapes(char *file_name)
{
	int counter;
	string name;
	double x,y,z;
	int i;
	ifstream ifs(file_name,std::ifstream::in);
	ifs >> counter;
	//@@Insert your code here

	list<Shape *> myShape;
    for (i=0;i<counter;i++){
		ifs >> name;
		if(name == "Rectangle"){
			ifs >> x >> y;
			myShape.insert(myShape.end(),new Rectangle<double>(x,y));
		}
		else if(name == "Circle"){
			ifs >> x;
			myShape.insert(myShape.end(), new Circle(x));
		}
		else if(name == "RectPrism"){
			ifs >> x >> y >>z;
			myShape.insert(myShape.end(),new RectPrism(x,y,z));
		}
		else if(name == "Sphere"){
			ifs >> x;
			myShape.insert(myShape.end(),new Sphere(x));
		}
	}
	ifs.close();

	return myShape;
}

// call getArea() of each object
// return the max area
static double MaxArea(list<Shape *> shapes)
{
	double a,b=0;
	for (list<Shape*>::iterator it =shapes.begin(); it != shapes.end(); it++) {
		a = (*it)->getArea();
		if(b<a){
			b=a;
		}

    
    }

	return b;
}

// call getVolume() of each object
// return the max volume
static double MaxVolume(list<Shape *> shapes)
{
	
	double a,b=0;
	for (list<Shape*>::iterator it =shapes.begin(); it != shapes.end(); it++) {
		a = (*it)->getVolume();
		if(b<a){
			b=a;
		}

    
    }
	return b;
}
#endif
