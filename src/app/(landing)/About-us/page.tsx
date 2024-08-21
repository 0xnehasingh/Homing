import React from 'react';

const AboutUs: React.FC = () => {
	return (
		<div className="min-h-screen bg-gradient-to-b from-blue-100 to-blue-200 text-gray-800">
			{/* Header */}
			<header className="bg-gradient-to-r from-cyan-500 via-blue-500 to-purple-500 py-12">
				<div className="container mx-auto text-center">
					<h1 className="text-6xl font-extrabold text-white tracking-wider">Homing</h1>
					<p className="text-xl text-blue-200 mt-4">Bridging Real World Assets with Blockchain Technology</p>
				</div>
			</header>

			{/* Main Content */}
			<main className="container mx-auto py-16 px-4 md:px-8">
				<section className="mb-16">
					<div className="bg-white bg-opacity-80 backdrop-blur-lg rounded-xl shadow-2xl p-8 transform transition-all duration-300 hover:scale-105">
						<h2 className="text-4xl font-bold text-blue-600 mb-4">Our Vision</h2>
						<p className="text-lg text-gray-700 leading-relaxed">
							Homing is at the forefront of merging traditional real estate with blockchain technology. Our vision is to
							create a transparent and secure environment where real estate investments are accessible to everyone, from
							anywhere in the world.
						</p>
					</div>
				</section>

				<section className="mb-16">
					<div className="bg-white bg-opacity-80 backdrop-blur-lg rounded-xl shadow-2xl p-8 transform transition-all duration-300 hover:scale-105">
						<h2 className="text-4xl font-bold text-blue-600 mb-4">Our Mission</h2>
						<p className="text-lg text-gray-700 leading-relaxed">
							Our mission is to democratize real estate investments by leveraging the power of blockchain. We aim to
							provide fractional ownership opportunities, allowing individuals to diversify their portfolios with ease
							and confidence.
						</p>
					</div>
				</section>

				<section className="mb-16">
					<div className="bg-white bg-opacity-80 backdrop-blur-lg rounded-xl shadow-2xl p-8 transform transition-all duration-300 hover:scale-105">
						<h2 className="text-4xl font-bold text-blue-600 mb-4">Meet the Creators</h2>
						<p className="text-lg text-gray-700 leading-relaxed">
							Homing is led by <strong>Neha Singh</strong> and <strong>Qadir Killedar</strong>, visionaries in the
							fields of blockchain and real estate. Their combined expertise drives Homing’s innovative approach to real
							estate investments.
						</p>
					</div>
				</section>

				<section className="mb-16">
					<div className="bg-white bg-opacity-80 backdrop-blur-lg rounded-xl shadow-2xl p-8 transform transition-all duration-300 hover:scale-105">
						<h2 className="text-4xl font-bold text-blue-600 mb-4">Why Choose Homing?</h2>
						<p className="text-lg text-gray-700 leading-relaxed">
							By choosing Homing, you become part of a forward-thinking community that believes in the transformative
							potential of blockchain. Our platform offers unparalleled security, transparency, and the ability to
							invest in real estate assets seamlessly.
						</p>
					</div>
				</section>
			</main>
			<footer className="bg-gradient-to-r from-white to-blue-50 text-gray-800 py-12">
				<div className="container mx-auto px-6">
					<div className="grid grid-cols-1 md:grid-cols-4 gap-8">
						<div>
							<h3 className="text-xl font-bold text-blue-700 mb-4">GoHomes</h3>
							<p className="text-gray-600">Revolutionizing real estate investment through tokenization.</p>
						</div>
						<div>
							<h3 className="text-lg font-semibold text-blue-700 mb-4">Quick Links</h3>
							<ul className="space-y-2">
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Home
									</a>
								</li>
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Properties
									</a>
								</li>
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										About Us
									</a>
								</li>
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Contact
									</a>
								</li>
							</ul>
						</div>
						<div>
							<h3 className="text-lg font-semibold text-blue-700 mb-4">Legal</h3>
							<ul className="space-y-2">
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Terms of Service
									</a>
								</li>
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Privacy Policy
									</a>
								</li>
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Cookie Policy
									</a>
								</li>
							</ul>
						</div>
						<div>
							<h3 className="text-lg font-semibold text-blue-700 mb-4">Connect</h3>
							<ul className="space-y-2">
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Twitter
									</a>
								</li>
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										LinkedIn
									</a>
								</li>
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Facebook
									</a>
								</li>
								<li>
									<a href="#" className="hover:text-blue-600 transition-colors duration-300">
										Instagram
									</a>
								</li>
							</ul>
						</div>
					</div>
					<div className="mt-8 pt-8 border-t border-blue-200 text-center">
						<p className="text-gray-600">&copy; 2024 GoHomes. All rights reserved.</p>
					</div>
				</div>
			</footer>
		</div>
	);
};

export default AboutUs;