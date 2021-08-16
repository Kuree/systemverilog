class Dog {
public:
    Dog(): distance_(0) {}
    void run(int distance) {
        distance_ += distance;
    }

    int distance() const { return distance_; }

private:
    int distance_;
};

// export function to C
extern "C" {
void *dog_ctor() {
    return new Dog();
}

void dog_dctor(void *dog) {
    auto *ptr = reinterpret_cast<Dog*>(dog);
    delete ptr;
}

void dog_run(void *dog, int distance) {
    auto *ptr = reinterpret_cast<Dog*>(dog);
    ptr->run(distance);
}

int dog_distance(void *dog) {
    auto *ptr = reinterpret_cast<Dog*>(dog);
    return ptr->distance();
}
}
