<p align="center">
    <img src="litha-icon-np.png">
</p>
<h1 align="center">Litha</h1>

> *Important!* This library is still under construction, so it might not be suitable for production use cases just yet. However, your contributions and feedback can help us expedite its readiness for broader usage. This README describes what Litha will become when it is ready. As of now, **features are not implemented yet**.

Litha is a powerful library designed to cater to machine learning, neural networks, artificial intelligence, and deep learning operations in the Zig programming language.

## Why Litha?

It's true that there are many mature and well-supported AI/ML/DL libraries in the programming world. Litha, however, comes with its unique benefits that make it worth considering for your machine learning projects:

### 1. Self Contained

Litha aims to be a fully self-contained library for machine learning in Zig. This means it brings everything you need to build, train, and deploy machine learning models without requiring numerous dependencies or additional libraries. With Litha, you get all the tools you need in a single, unified package, making your machine learning projects easier to manage and maintain.

### 2. Compile Time Abilities

One of the unique features of Litha, empowered by the capabilities of Zig, is its extensive use of compile-time abilities. These abilities can be leveraged to optimize machine learning models, tune performance critical parameters, and perform sophisticated type-level computations, all at compile-time.

This can lead to highly efficient code execution and performance improvements, as a lot of decisions are made at compile-time rather than at run-time. This also contributes to the predictability and robustness of the models built with Litha, as potential issues can be caught at compile-time, reducing the likelihood of run-time errors.

### 3. Value Through Convenience

Litha is not just a general machine learning library, it is also a toolbox for training and deploying models. With Zig's build system, Litha can do a slew of neat tricks:
- Embed an already existing model into executable (or a library), ready to be used at run-time, just like a dependency.
- Generate code for the model for training and inference. Train a model with a single build step (`zig build train`)

### 4. API Inclusivity and Flexibility

In contrast to many machine learning libraries that heavily depend on CUDA and therefore NVIDIA hardware, Litha embraces an inclusive and flexible approach to APIs. While Litha does support CUDA when it's available, it also provides compatibility with a wide variety of open APIs such as Vulkan and OpenCL, as well as proprietary APIs like DirectX and Metal. This means you can run Litha on almost any hardware, whether it's a GPU or just a CPU.

This inclusive approach eliminates the limitations and vendor lock-ins associated with being tied to a specific hardware or API. With Litha, you have the freedom to use the resources that are available to you, and the flexibility to switch between different APIs as needed.

By choosing Litha, you are opting for a machine learning library that values flexibility, inclusivity, and your freedom to choose. Whether you're developing on a high-end machine with the latest GPU or on a less powerful device with CPU-only, Litha has you covered.

## Why Zig?

Zig is an emerging language that is designed to be simple, reliable, and efficient, filling a unique niche in the programming world. Here's why we chose Zig for the Litha library:

### 1. Simplicity and Readability
Zig aims to be simple and straightforward. There are no hidden behaviors or complex abstractions. This means the code you write is the code that gets executed, leading to highly predictable and easy-to-debug programs.

### 2. Performance
Zig enables low-level programming without losing high-level convenience. It provides manual memory management and other low-level features, making it possible to write extremely efficient code.

### 3. Control
Zig offers robust control over system resources, allowing direct management of memory allocation and hardware. It also supports compiling to C, enabling interoperability with a vast number of existing libraries.

### 4. Safety
While Zig gives you a lot of power, it also encourages writing safe code. It has built-in features to handle errors explicitly and avoid undefined behavior.

### 5. Community
The Zig community is vibrant and growing. This provides a pool of shared knowledge and resources for developers working in Zig.

In summary, Zig’s blend of simplicity, efficiency, control, safety, and community makes it a great fit for Litha. We believe that Zig's philosophy aligns with our goals to provide a simple, efficient, and powerful library for machine learning and AI.

The "official" IRC channel is #litha on Libera.Chat.

## License

The primary mission of Litha, like the Zig project, is to serve users. This doesn't only mean the developers who use Litha to build machine learning and AI models, but more importantly, the end-users who benefit from the applications created using this library.

Our aim is for Litha to be a tool that empowers end-users, not to exploit them financially or restrict their freedom to interact with hardware or software in any way.

We firmly believe in fostering a culture of open-source collaboration and sharing. However, setting up social norms around these values tends to be a more effective way to ensure their adherence than complicating software licenses. As such, complicating the software license of Litha could potentially jeopardize the value it brings to its users.

Therefore, Litha is released under the MIT (Expat) License, coupled with a simple request: use it to improve how software caters to the needs of end-users.