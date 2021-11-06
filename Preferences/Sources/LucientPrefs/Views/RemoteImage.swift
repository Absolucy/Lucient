//  Copyright (c) 2021 Lucy <lucy@absolucy.moe>
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Combine
import SwiftUI
import UIKit

protocol ImageCache {
	subscript(_: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
	private let cache: NSCache<NSURL, UIImage> = {
		let cache = NSCache<NSURL, UIImage>()
		cache.countLimit = 8
		cache.totalCostLimit = 1024 * 1024 * 10
		return cache
	}()

	subscript(_ key: URL) -> UIImage? {
		get { cache.object(forKey: key as NSURL) }
		set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
	}
}

class ImageLoader: ObservableObject {
	@Published var image: UIImage?

	private(set) var isLoading = false

	private let url: URL
	private var cache: ImageCache?
	private var cancellable: AnyCancellable?

	private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
	private static let session: URLSession = {
		let delegateQueue = OperationQueue()
		delegateQueue.qualityOfService = .userInteractive
		return URLSession(configuration: .default, delegate: nil, delegateQueue: delegateQueue)
	}()

	init(url: URL, cache: ImageCache? = nil) {
		self.url = url
		self.cache = cache
	}

	deinit {
		cancel()
	}

	func load() {
		guard !isLoading else { return }

		if let image = cache?[url] {
			self.image = image
			return
		}

		cancellable = ImageLoader.session.dataTaskPublisher(for: url)
			.map { UIImage(data: $0.data) }
			.replaceError(with: nil)
			.handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
			              receiveOutput: { [weak self] in self?.cache($0) },
			              receiveCompletion: { [weak self] _ in self?.onFinish() },
			              receiveCancel: { [weak self] in self?.onFinish() })
			.subscribe(on: Self.imageProcessingQueue)
			.receive(on: DispatchQueue.main)
			.sink { [weak self] in self?.image = $0 }
	}

	func cancel() {
		cancellable?.cancel()
	}

	private func onStart() {
		isLoading = true
	}

	private func onFinish() {
		isLoading = false
	}

	private func cache(_ image: UIImage?) {
		image.map { cache?[url] = $0 }
	}
}

struct ImageCacheKey: EnvironmentKey {
	static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
	var imageCache: ImageCache {
		get { self[ImageCacheKey.self] }
		set { self[ImageCacheKey.self] = newValue }
	}
}

struct AsyncImage<Placeholder: View>: View {
	@StateObject private var loader: ImageLoader
	private let placeholder: Placeholder
	private let image: (UIImage) -> Image

	init(
		url: URL,
		@ViewBuilder placeholder: () -> Placeholder,
		@ViewBuilder image: @escaping (UIImage) -> Image = Image.init(uiImage:)
	) {
		self.placeholder = placeholder()
		self.image = image
		_loader = StateObject(wrappedValue: ImageLoader(url: url, cache: Environment(\.imageCache).wrappedValue))
	}

	var body: some View {
		content
			.onAppear(perform: loader.load)
	}

	private var content: some View {
		Group {
			if let loadedImage = loader.image {
				image(loadedImage)
					.resizable()
			} else {
				placeholder
			}
		}
	}
}
