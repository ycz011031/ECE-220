#include <iostream>
using namespace std;

class Shape{
	private:
	int color;
	protected:
	double width, height;
	public:
	void set_color(int c){color = c;}
	int get_color(){return color;}
	Shape() {width = 1; height = 1; color=1;}
	Shape(double a, double b, int c) { width = a; height = b; color = c;}
	double area() { cout << "Base class area unknown." << endl; return 0;}
};

class Rectangle : public Shape{
	public:
	Rectangle(double a, double b){width = a; height = b;}
	double area() { 
		cout << "Rectangle object area is " << width*height << endl;
		return (double)width*height; }
};

class Triangle : public Shape{
	public:
	Triangle(double a, double b){width = a; height = b;}
	double area() {
		cout << "Triangle object area is " << width*height*0.5 << endl;
		return (double)width*height*0.5; }
};


//What does this program print?
//What needs to be changed to call the area function defined in derived class?
int main(){
	Shape shape1(1,2,3);
	Rectangle rec(3,5);
	Triangle tri(3,5);

	rec.set_color(2);
	cout<<"Rectangle's color is: " <<rec.get_color()<<endl;

	tri.set_color(3);
	cout<<"Triangle's color is: " <<tri.get_color()<<endl;
/*
	shape1.area();
	rec.area();
	tri.area();
*/


	Shape *ptr;
	ptr = &shape1;
	ptr->area();

	//use ptr to point to rec
	ptr = &rec;
	ptr->area();

	//use ptr to point to tri
	ptr = &tri;
	ptr->area();

	return 0;

}

